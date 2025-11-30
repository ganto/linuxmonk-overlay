# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C implementation of createrepo"
HOMEPAGE="https://rpm-software-management.github.io/createrepo_c"
SRC_URI="
	https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/rpm-software-management/createrepo_c/commit/4e37bc582b1673ff767dbd0b570ef1c8871d3e8c.patch
		-> ${PN}-1.2.1-r2-rpm6compat.patch
	https://github.com/rpm-software-management/createrepo_c/commit/89fa02828cdaf1c710c38bde5fcbcf59538a9cce.patch
		-> ${PN}-1.2.1-r2-cmake4.patch
	https://github.com/rpm-software-management/createrepo_c/commit/0a2da7c87ae9b7e3e11e77416a8e75633d4608a0.patch
		-> ${PN}-1.2.1-r3-conditional-deps.patch
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc drpm legacy modulemd test zchunk"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? (
		app-text/doxygen
		dev-python/sphinx
	)
"

DEPEND="
	app-arch/bzip2:=
	app-arch/rpm:=
	app-arch/xz-utils
	app-arch/zstd:=
	>=dev-db/sqlite-3.6.18:3
	dev-libs/glib:2
	dev-libs/libxml2:=
	dev-libs/openssl:=
	net-misc/curl
	sys-apps/file
	virtual/zlib:=
	drpm? ( >=app-arch/drpm-0.4.0 )
	modulemd? ( >=sys-libs/libmodulemd-2.3 )
	zchunk? ( app-arch/zchunk )
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${DISTDIR}/${PN}-1.2.1-r2-cmake4.patch"
	"${DISTDIR}/${PN}-1.2.1-r2-rpm6compat.patch"
	"${DISTDIR}/${PN}-1.2.1-r3-conditional-deps.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_DRPM=$(usex drpm ON OFF)
		# As best I can tell, this enables distribution as a wheel. No need for this on gentoo!
		-DENABLE_PYTHON=OFF
		# Upstream enables some 'Legacy' stuff by default, let's put that behind a USE flag
		-DENABLE_LEGACY_WEAKDEPS=$(usex legacy ON OFF)
		-DWITH_LEGACY_HASHES=$(usex legacy ON OFF)
		-DWITH_LIBMODULEMD=$(usex modulemd)
		-DWITH_SANITIZERS=OFF
		-DWITH_ZCHUNK=$(usex zchunk)
		-Wno-dev
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	# Tests have a magic target!
	use test && cmake_src_compile tests
	use doc && cmake_src_compile doc-c
}

src_test() {
	"${S}"_build/tests/run_tests.sh || die "Failed to run C library tests"
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${BUILD_DIR}/doc/html" examples
}
