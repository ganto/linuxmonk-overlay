# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson vala xdg

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://launchpad.net/deja-dup/"
SRC_URI="https://gitlab.gnome.org/World/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gnome-online-accounts nautilus test"

COMMON_DEPEND="
	>=app-crypt/libsecret-0.18.6[vala]
	>=dev-libs/glib-2.56:2[dbus]
	>=dev-libs/json-glib-1.2
	>=net-libs/libsoup-2.48:2.4
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/libnotify-0.7

	>=app-backup/duplicity-0.6.23

	gnome-online-accounts? ( net-libs/gnome-online-accounts )
	nautilus? ( gnome-base/nautilus )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	gnome-base/gvfs[fuse]
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-util/desktop-file-utils
	virtual/pkgconfig
	sys-devel/gettext
"

RESTRICT="test" # bug#????

PATCHES=( "${FILESDIR}"/40.2-meson-disable-optional.patch )

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	meson_src_configure \
		$(meson_use gnome-online-accounts enable_goa) \
		$(meson_use nautilus enable_nautilus) \
		-Denable_packagekit=false
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
