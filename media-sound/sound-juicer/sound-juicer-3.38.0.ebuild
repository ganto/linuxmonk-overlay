# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="CD ripper for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/SoundJuicer"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="flac test vorbis"
RESTRICT="!test? ( test )"

DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.49.5:2[dbus]
	>=x11-libs/gtk+-3.21.6:3
	media-libs/libcanberra[gtk3]
	>=app-cdr/brasero-2.90
	sys-apps/dbus
	gnome-base/gsettings-desktop-schemas

	>=media-libs/libdiscid-0.4.0
	>=media-libs/musicbrainz-5.0.1:5=

	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0[vorbis?]
	flac? ( media-plugins/gst-plugins-flac:1.0 )
"
RDEPEND="${DEPEND}
	gnome-base/gvfs[cdda,udev]
	|| (
		media-plugins/gst-plugins-cdparanoia:1.0
		media-plugins/gst-plugins-cdio:1.0 )
	media-plugins/gst-plugins-meta:1.0
"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	test? ( ~app-text/docbook-xml-dtd-4.3 )
"

src_prepare() {
	xdg_src_prepare

	# don't install doc files via meson
	sed -i '/^install_data/d' meson.build || die
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
