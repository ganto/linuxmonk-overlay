# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION=0.40
inherit gnome.org meson systemd vala xdg

DESCRIPTION="Rygel is an open source UPnP/DLNA MediaServer"
HOMEPAGE="https://wiki.gnome.org/Projects/Rygel"

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X +introspection tracker test transcode"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/libunistring:=
	>=dev-db/sqlite-3.5:3
	>=dev-libs/glib-2.56.0:2
	>=dev-libs/libgee-0.8:0.8
	>=dev-libs/libxml2-2.7:2
	>=media-libs/gupnp-dlna-0.9.4:2.0
	>=media-libs/gstreamer-1.12:1.0
	>=media-libs/gstreamer-editing-services-1.16:1.0
	>=media-libs/gst-plugins-base-1.12:1.0
	>=media-libs/libmediaart-0.7:2.0
	media-plugins/gst-plugins-soup:1.0
	>=net-libs/gssdp-1.1.0:0=
	>=net-libs/gupnp-1.1.0:0=
	>=net-libs/gupnp-av-0.12.8
	>=net-libs/libsoup-2.44:2.4
	>=sys-apps/util-linux-2.20
	x11-libs/gdk-pixbuf:2
	x11-misc/shared-mime-info
	introspection? ( >=dev-libs/gobject-introspection-1.33.4:= )
	tracker? ( >=app-misc/tracker-3.0:3 )
	transcode? (
		media-libs/gst-plugins-bad:1.0
		media-plugins/gst-plugins-twolame:1.0
		media-plugins/gst-plugins-libav:1.0
	)
	X? ( >=x11-libs/gtk+-3.22:3 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gtk-doc-am
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local plugins="external,gst-launch,lms,media-export,mpris,playbin"
	use tracker && plugins+=",tracker3"

	local emesonargs=(
		-Dapi-docs=false
		-Dengines=gstreamer
		-Dexamples=false
		-Dgstreamer=enabled
		-Dplugins=${plugins}
		-Dsystemd-user-units-dir=$(systemd_get_userunitdir)
		$(meson_feature X gtk)
		$(meson_feature introspection)
		$(meson_use test tests)
	)
	meson_src_configure
}
