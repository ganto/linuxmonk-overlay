# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson vala

DESCRIPTION="Disk usage browser for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Baobab"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

COMMON_DEPEND="
	>=dev-libs/glib-2.44:2[dbus]
	>=x11-libs/gtk+-3.20:3
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/gsettings-desktop-schemas
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_src_prepare
}
