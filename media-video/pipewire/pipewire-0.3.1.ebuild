# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Multimedia processing graphs"
HOMEPAGE="https://pipewire.org/"
SRC_URI="https://github.com/PipeWire/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/0.3"

KEYWORDS="~amd64"
IUSE="alsa bluetooth doc ffmpeg jack libav gstreamer pulseaudio systemd v4l2 vulkan"

BDEPEND="
	app-doc/xmltoman
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
	)
"
DEPEND="
	media-libs/libsndfile
	sys-apps/dbus
	virtual/libudev
	alsa? ( media-libs/alsa-lib )
	bluetooth? (
		media-libs/sbc
		>=net-wireless/bluez-4.101
	)
	ffmpeg? (
		!libav? ( media-video/ffmpeg:= )
		libav? ( media-video/libav:= )
	)
	gstreamer? (
		>=dev-libs/glib-2.32.0
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	jack? ( media-sound/jack )
	pulseaudio? ( >=media-sound/pulseaudio-11.1 )
	systemd? ( sys-apps/systemd )
	vulkan? ( dev-util/vulkan-headers )
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		-Devl=false
		-Dexamples=false
		-Dman=true
		$(meson_use alsa)
		$(meson_use alsa pipewire-alsa)
		$(meson_use bluetooth bluez5)
		$(meson_use doc docs)
		$(meson_use ffmpeg)
		$(meson_use gstreamer)
		$(meson_use jack)
		$(meson_use jack pipewire-jack)
		$(meson_use pulseaudio pipewire-pulseaudio)
		$(meson_use systemd)
		$(meson_use v4l2)
		$(meson_use vulkan)
	)
	meson_src_configure
}

pkg_postinst() {
	elog "Package has optional sys-auth/rtkit RUNTIME support that may be"
	elog "disabled by setting DISABLE_RTKIT env var."
}
