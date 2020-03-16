# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org meson virtualx xdg

DESCRIPTION="GNOME color profile tools"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-color-manager/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

# Need gtk+-3.3.8 for https://bugzilla.gnome.org/show_bug.cgi?id=673331
# vte could be made optional
DEPEND="
	>=dev-libs/glib-2.31.10:2
	>=media-libs/lcms-2.2:2
	>=media-libs/libcanberra-0.10[gtk3]

	>=x11-libs/gtk+-3.3.8:3
	>=x11-misc/colord-1.3.1:0=
	>=x11-libs/colord-gtk-0.1.20
"
RDEPEND="${DEPEND}"
# docbook-sgml-{utils,dtd:4.1} needed to generate man pages
BDEPEND="
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( "${RDEPEND}" )
"

src_prepare() {
	xdg_src_prepare

	# Fix hard-coded package name
	# https://gitlab.gnome.org/GNOME/gnome-color-manager/issues/3
	sed 's:argyllcms:media-gfx/argyllcms:' -i src/gcm-utils.h || die
}

src_configure() {
	# Always enable tests since they are check_PROGRAMS anyway
	local emesonargs=(
		$(meson_use test tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! has_version media-gfx/argyllcms ; then
		elog "If you want to do display or scanner calibration, you will need to"
		elog "install media-gfx/argyllcms"
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
}
