# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome.org meson multilib-minimal

DESCRIPTION="Internationalized text layout and rendering library"
HOMEPAGE="https://www.pango.org/"

LICENSE="LGPL-2+ FTL"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"

IUSE="X +introspection test"

RDEPEND="
	>=media-libs/harfbuzz-2.0.0:=[glib(+),truetype(+),${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.60.0:2[${MULTILIB_USEDEP}]
	>=media-libs/fontconfig-2.12.92:1.0=[${MULTILIB_USEDEP}]
	>=media-libs/freetype-2.5.0.1:2=[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4:=[X?,${MULTILIB_USEDEP}]
	>=dev-libs/fribidi-0.19.7[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5:= )
	X? (
		>=x11-libs/libXrender-0.9.8[${MULTILIB_USEDEP}]
		>=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}]
		>=x11-libs/libXft-2.3.1-r1[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.20
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	test? ( media-fonts/cantarell )
	X? ( x11-base/xorg-proto )
	!<=sys-devel/autoconf-2.63:2.5
"

multilib_src_configure() {
	local emesonargs=(
		-Dintrospection=$(multilib_native_usex introspection true false)
	)
	meson_src_configure
}

multilib_src_compile() { meson_src_compile; }

multilib_src_test() { meson_src_test; }

multilib_src_install() { meson_src_install; }
