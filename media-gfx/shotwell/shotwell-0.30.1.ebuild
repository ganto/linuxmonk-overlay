# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.28"

inherit gnome2 meson vala

DESCRIPTION="Shotwell is a photo manager for GNOME 3"
HOMEPAGE="https://wiki.gnome.org/Apps/Shotwell/"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-crypt/gcr:=[gtk,vala]
	>=dev-db/sqlite-3.5.9:3
	dev-libs/json-glib:=
	dev-libs/libgdata:=[vala]
	dev-libs/libxml2:=
	>=dev-libs/libgee-0.8.5:=
	>=media-libs/gexiv2-0.10.4:=[introspection,vala]
	media-libs/gstreamer:1.0
	>=media-libs/libexif-0.6.16:=
	>=media-libs/libgphoto2-2.5:=
	>=media-libs/libraw-0.13.2:=
	>=net-libs/libsoup-2.4:=
	>=net-libs/webkit-gtk-2.4:=
	x11-libs/gdk-pixbuf:=
	>=x11-libs/gtk+-3.22:=[X]
"
DEPEND="
	${RDEPEND}
	$(vala_depend)
	dev-util/itstool
"

src_prepare() {
	vala_src_prepare
	eapply_user
}
