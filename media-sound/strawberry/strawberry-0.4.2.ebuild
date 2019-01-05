# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome.org xdg-utils

DESCRIPTION="Audio player and music collection organizer"
HOMEPAGE="https://strawbs.org/ https://github.com/jonaski/strawberry"
SRC_URI="https://files.jkvinge.net/packages/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cdda chromaprint +dbus debug +gstreamer iphone ipod lastfm mtp phonon pulseaudio test +udisks vlc"
RESTRICT="test"

REQUIRED_USE="
	|| ( gstreamer phonon vlc )
	iphone? ( ipod )
	udisks? ( dbus )
"

COMMON_DEPEND="
	app-crypt/qca:2[qt5(+)]
	dev-db/sqlite:=
	dev-libs/crypto++[asm]
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/protobuf:=
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	>=media-libs/libmygpo-qt-1.0.9[qt5(+)]
	>=media-libs/taglib-1.11.1_p20181028
	virtual/glu
	x11-libs/libX11
	cdda? ( dev-libs/libcdio:= )
	chromaprint? ( media-libs/chromaprint:= )
	dbus? ( dev-qt/qtdbus:5 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	iphone? (
		>=app-pda/libimobiledevice-1.1.1
		app-pda/libplist
		app-pda/usbmuxd
	)
	ipod? ( >=media-libs/libgpod-0.8.0 )
	lastfm? ( >=media-libs/liblastfm-1.1.0_pre20150206 )
	mtp? ( >=media-libs/libmtp-1.0.0 )
	phonon? ( >=media-libs/phonon-4 )
	vlc? ( media-video/vlc )
"
RDEPEND="${COMMON_DEPEND}
	gstreamer? (
		media-plugins/gst-plugins-meta:1.0
		media-plugins/gst-plugins-taglib:1.0
	)
	mtp? ( gnome-base/gvfs[mtp] )
	udisks? ( sys-fs/udisks:2 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-cpp/gtest-1.8.0
	dev-libs/boost
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	sys-devel/gettext
	virtual/pkgconfig
	pulseaudio? ( media-sound/pulseaudio )
	test? (
		dev-qt/qttest:5
		gnome-base/gsettings-desktop-schemas
	)
"

DOCS=( Changelog README.md )

src_configure() {
	local mycmakeargs=(
		-DBUILD_WERROR=OFF
		# avoid automagically enabling of ccache (bug #611010)
		-DCCACHE_EXECUTABLE=OFF
		# backends
		-DENABLE_DEEZER=OFF
		-DENABLE_PHONON="$(usex phonon)"
		-DENABLE_VLC="$(usex vlc)"
		-DENABLE_XINE=OFF
		# optional components
		-DENABLE_DEVICEKIT=OFF
		-DENABLE_DZMEDIA=OFF
		-DENABLE_GIO=ON
		-DENABLE_AUDIOCD="$(usex cdda)"
		-DENABLE_CHROMAPRINT="$(usex chromaprint)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5DBus=$(usex !dbus)
		-DENABLE_LIBGPOD="$(usex ipod)"
		-DENABLE_LIBLASTFM="$(usex lastfm)"
		-DENABLE_LIBMTP="$(usex mtp)"
		-DENABLE_LIBPULSE="$(usex pulseaudio)"
		-DENABLE_UDISKS2="$(usex udisks)"
	)

	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update

	elog "Note that list of supported formats is controlled by media-plugins/gst-plugins-meta "
	elog "USE flags. You may be interested in setting aac, flac, mp3, ogg or wavpack USE flags "
	elog "depending on your preferences"
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
