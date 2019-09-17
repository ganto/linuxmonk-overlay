# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson

DESCRIPTION="A quick previewer for Nautilus, the GNOME file manager"
HOMEPAGE="https://git.gnome.org/browse/sushi"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="office wayland"

COMMON_DEPEND="
	>=x11-libs/gdk-pixbuf-2.23[introspection]
	>=dev-libs/gjs-1.38.0
	>=dev-libs/glib-2.29.14:2
	>=dev-libs/gobject-introspection-0.9.6:=
	>=media-libs/clutter-1.11.4:1.0[introspection]
	>=media-libs/clutter-gtk-1.0.1:1.0[introspection]
	>=x11-libs/gtk+-3.13.2:3[X,introspection,wayland?]

	>=app-text/evince-3.0[introspection]
	media-libs/freetype:2
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	>=media-libs/harfbuzz-0.9.9:=
	media-libs/clutter-gst:3.0[introspection]
	media-libs/libepoxy
	media-libs/musicbrainz:5=
	net-libs/webkit-gtk:4[introspection]
	>=x11-libs/gtksourceview-4.0.3:4[introspection]

	office? ( app-office/libreoffice )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/nautilus-3.30.0
"