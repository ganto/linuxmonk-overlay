# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="User-friendly tool for creating bootable media for Raspberry Pi devices"
HOMEPAGE="https://github.com/raspberrypi/rpi-imager"
SRC_URI="https://github.com/raspberrypi/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-arch/libarchive-3.2.0
	app-arch/lzma
	dev-qt/linguist-tools
	dev-qt/qtcore
	dev-qt/qtdbus
	dev-qt/qtsvg
	dev-qt/qtquickcontrols2
	dev-qt/qtwidgets
	net-libs/gnutls
	>=net-misc/curl-7.32.0
	sys-apps/util-linux
	sys-fs/dosfstools
	sys-fs/udisks:2
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DENABLE_CHECK_VERSION=OFF
		-DENABLE_TELEMETRY=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman ../doc/man/${PN}.1
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
