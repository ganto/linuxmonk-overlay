# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit cmake python-r1

DESCRIPTION="Comps XML file manipulation library"
HOMEPAGE="https://github.com/rpm-software-management/libcomps"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${P}/libcomps"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="
	mirror
	!test? ( test )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/expat
	dev-libs/libxml2
	virtual/zlib
"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

src_configure() {
	python_foreach_impl cmake_src_configure
}

src_compile() {
	python_foreach_impl cmake_src_compile
}

libcomps_src_install_internal() {
	pushd "${BUILD_DIR}"
	cmake_src_install
	python_optimize
	popd
}

src_install() {
	python_foreach_impl libcomps_src_install_internal
}

libcomps_src_test_internal() {
	pushd "${BUILD_DIR}"/src/python/tests >/dev/null || die "Failed to change to test directory"
	epytest
	popd
}

src_test() {
	python_foreach_impl libcomps_src_test_internal
}
