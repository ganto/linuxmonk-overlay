# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C implementation of createrepo"
HOMEPAGE="https://rpm-software-management.github.io/createrepo_c"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc drpm legacy modulemd test zchunk"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/bzip2:=
	app-arch/rpm:=
	app-arch/xz-utils
	app-arch/zstd:=
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/openssl:=
	net-misc/curl
	sys-apps/file
	sys-libs/zlib:=
	drpm? ( >=app-arch/drpm-0.4.0 )
	modulemd? ( >=sys-libs/libmodulemd-2.3 )
	zchunk? ( app-arch/zchunk )
"
BDEPEND="
	doc? (
		app-text/doxygen
		dev-python/sphinx
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DRPM=$(usex drpm)
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
	use doc && cmake_src_compile doc-c
	# Tests have a magic target!
	use test && cmake_src_compile tests
}

src_install() {
	cmake_src_install

	if use doc; then
		dodoc -r examples
		local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
		einstalldocs
	fi
}

src_test() {
	"${S}"_build/tests/run_tests.sh || die "Failed to run C library tests"
}
