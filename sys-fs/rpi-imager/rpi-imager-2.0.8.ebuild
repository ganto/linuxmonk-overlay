# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="User-friendly tool for creating bootable media for Raspberry Pi devices"
HOMEPAGE="https://github.com/raspberrypi/rpi-imager"

LIBARCHIVE_PV="3.8.6"
CURL_PV="8.19.0"
NGHTTP2_PV="1.68.1"
ZSTD_PV="1.5.7"
ZLIB_PV="1.3.2"
XZ_PV="5.8.2"
LIBUSB_PV="1.0.29"

SRC_URI="
	https://github.com/raspberrypi/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/libarchive/libarchive/archive/refs/tags/v${LIBARCHIVE_PV}.tar.gz -> libarchive-${LIBARCHIVE_PV}.tar.gz
	https://github.com/curl/curl/archive/refs/tags/curl-${CURL_PV//./_}.tar.gz -> curl-${CURL_PV}.tar.gz
	https://github.com/nghttp2/nghttp2/archive/refs/tags/v${NGHTTP2_PV}.tar.gz -> nghttp2-${NGHTTP2_PV}.tar.gz
	https://github.com/facebook/zstd/archive/refs/tags/v${ZSTD_PV}.tar.gz -> zstd-${ZSTD_PV}.tar.gz
	https://github.com/madler/zlib/archive/refs/tags/v${ZLIB_PV}.tar.gz -> zlib-${ZLIB_PV}.tar.gz
	https://github.com/tukaani-project/xz/archive/refs/tags/v${XZ_PV}.tar.gz -> xz-${XZ_PV}.tar.gz
	https://github.com/libusb/libusb/archive/refs/tags/v${LIBUSB_PV}.tar.gz -> libusb-${LIBUSB_PV}.tar.gz
"
S="${WORKDIR}/${P}/src"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# curl, libarchive, nghttp2, zstd, zlib, xz, libusb are bundled as static libs
RDEPEND="
	dev-qt/qtbase:6[dbus,gui,network]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	dev-libs/nettle
	net-dns/libidn2
	net-libs/gnutls
	sys-apps/util-linux
	sys-fs/dosfstools
	sys-fs/udisks:2
	sys-libs/liburing
	virtual/libudev
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6
	virtual/pkgconfig
"

src_prepare() {
	eapply "${FILESDIR}/${P}-zstd-fetchcontent-srcdir.patch"
	pwd
	sed -i "s/\"0.0.0-unknown\"/\"v${PV}\"/" cmake/GenerateVersion.cmake
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DENABLE_CHECK_VERSION=OFF
		-DENABLE_TELEMETRY=OFF
		-DGENERATE_TIMEZONES_FROM_IANA=OFF
		-DGENERATE_COUNTRIES_FROM_REGDB=OFF
		-DGENERATE_CAPITAL_CITIES=OFF
		-DFETCHCONTENT_FULLY_DISCONNECTED=ON
		-DFETCHCONTENT_SOURCE_DIR_LIBARCHIVE="${WORKDIR}/libarchive-${LIBARCHIVE_PV}"
		-DFETCHCONTENT_SOURCE_DIR_CURL="${WORKDIR}/curl-curl-${CURL_PV//./_}"
		-DFETCHCONTENT_SOURCE_DIR_NGHTTP2="${WORKDIR}/nghttp2-${NGHTTP2_PV}"
		-DFETCHCONTENT_SOURCE_DIR_ZSTD="${WORKDIR}/zstd-${ZSTD_PV}"
		-DFETCHCONTENT_SOURCE_DIR_ZLIB="${WORKDIR}/zlib-${ZLIB_PV}"
		-DFETCHCONTENT_SOURCE_DIR_XZ="${WORKDIR}/xz-${XZ_PV}"
		-DFETCHCONTENT_SOURCE_DIR_LIBUSB="${WORKDIR}/libusb-${LIBUSB_PV}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman ../doc/man/${PN}.1
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
