# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="GNOME contact management application"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Contacts"

LICENSE="GPL-2+"
SLOT="0"
IUSE="v4l"
KEYWORDS="~amd64"

VALA_DEPEND="
	$(vala_depend)
	>=dev-libs/gobject-introspection-1.54
	dev-libs/folks[vala(+)]
	net-libs/gnome-online-accounts[vala]
	gnome-extra/evolution-data-server[gtk,vala]
	gui-libs/libhandy:1[vala]
"
# Configure is wrong; it needs cheese-3.5.91, not 3.3.91
RDEPEND="
	>=gnome-extra/evolution-data-server-3.30:=[gnome-online-accounts]
	>=dev-libs/folks-0.14:=[eds]
	>=dev-libs/glib-2.58:2
	>=dev-libs/libgee-0.10:0.8
	>=gnome-base/gnome-desktop-3.0:3=
	net-libs/gnome-online-accounts:=
	>=x11-libs/gtk+-3.23.1:3
	v4l? ( >=media-video/cheese-3.5.91:= )
	>=gui-libs/libhandy-1.0.0:1=
"
DEPEND="${RDEPEND}"
BDEPEND="
	${VALA_DEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Ddocs=false
		-Dmanpage=true
		-Dtelepathy=false	# doesn't build anymore
		$(meson_feature v4l cheese)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}