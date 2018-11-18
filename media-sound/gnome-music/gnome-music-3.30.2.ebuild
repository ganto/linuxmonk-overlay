# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit gnome.org python-single-r1 meson

DESCRIPTION="Music management for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Music"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=app-misc/tracker-miners-2
	>=dev-python/pycairo-1.14.0[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.29.1:3[cairo,${PYTHON_USEDEP}]
	>=dev-libs/glib-2.28:2
	>=dev-libs/gobject-introspection-1.35.9:=
	>=dev-libs/libdazzle-3.28.0:=
	>=media-libs/grilo-0.3.4:0.3[introspection]
	>=media-libs/libmediaart-1.9.1:2.0[introspection]
	>=media-plugins/grilo-plugins-0.3.8[tracker]
	>=x11-libs/gtk+-3.19.3:3[introspection]
"
# xdg-user-dirs-update needs to be there to create needed dirs
# https://bugzilla.gnome.org/show_bug.cgi?id=731613
RDEPEND="${COMMON_DEPEND}
	app-misc/tracker-miners[gstreamer,miner-fs]
	x11-libs/libnotify[introspection]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-plugins/gst-plugins-meta:1.0
	x11-misc/xdg-user-dirs
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.26
	virtual/pkgconfig
"

pkg_setup() {
	python_setup
}

src_prepare() {
	default
	sed -e '/sys.path.insert/d' -i "${S}"/gnome-music.in || die "python fixup sed failed"
}

src_install() {
	meson_src_install
	python_fix_shebang "${D}"usr/bin/gnome-music
}
