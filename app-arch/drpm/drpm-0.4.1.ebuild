# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="A library for making, reading and applying deltarpm packages"
HOMEPAGE="https://github.com/rpm-software-management/drpm"
SRC_URI="https://github.com/rpm-software-management/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2+ BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test zstd"

COMMON_DEPEND="
	app-arch/bzip2
	app-arch/lzma
	app-arch/rpm
	dev-libs/openssl
	sys-libs/zlib
	zstd? ( >=app-arch/zstd-1.4.2 )
"
DEPEND="
	"${COMMON_DEPEND}"
	test? (
		>=dev-util/cmocka-1.0
		dev-util/valgrind
	)
"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	mycmakeargs=(
		-DENABLE_TESTS=$(usex test)
		-DWITH_ZSTD=$(usex zstd)
	)
	cmake-utils_src_configure
}

src_test() {
	myctestargs=( -VV )
	cmake-utils_src_test
}
