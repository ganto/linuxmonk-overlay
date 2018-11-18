# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2 meson multilib-minimal virtualx

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="~amd64"
# requires dbus connection
IUSE="-test"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.29.1[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.29.1[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.5[${MULTILIB_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/at-spi-1.32.0-r1
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	test? ( >=dev-libs/libxml2-2.9.1 )
"

src_prepare() {
	# Upstream forgot to put this in tarball, upstream #770615
	cp -n "${FILESDIR}"/${PN}-2.20.0-tests-data/*.xml "${S}"/tests/data/ || die

	gnome2_src_prepare
}

multilib_src_configure() { meson_src_configure; }
multilib_src_compile() { meson_src_compile; }
multilib_src_install() { meson_src_install; }
