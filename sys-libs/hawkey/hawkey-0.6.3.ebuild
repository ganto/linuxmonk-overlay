# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit cmake-utils python-r1

DESCRIPTION="High-level API for the libsolv library"
HOMEPAGE="https://github.com/rpm-software-management/hawkey"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${P}-1.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-libs/check
	dev-libs/expat
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	sys-libs/libsolv[${PYTHON_USEDEP}]
	sys-libs/zlib
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/hawkey-${P}-1"

src_prepare() {
	eapply_user

	# adjust python-3 specific tool names
	sed -i 's/sphinx-build-3/sphinx-build/' doc/CMakeLists.txt
	sed -i 's/nosetests-${PYTHON_MAJOR_DOT_MINOR_VERSION}/nosetests/' tests/python/tests/run_nosetests.in
}

hawkey_src_configure_internal() {
	local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
	mycmakeargs=( -DPYTHON_DESIRED=${python_major} )
	cmake-utils_src_configure
}

src_configure() {
	python_foreach_impl hawkey_src_configure_internal
}

hawkey_src_compile_internal() {
	cmake-utils_src_compile
	cmake-utils_src_compile doc
}

src_compile() {
	python_foreach_impl hawkey_src_compile_internal
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

hawkey_src_install_internal() {
	cmake-utils_src_install
	dohtml -r "${BUILD_DIR}"/doc/*

	# don't install test code
	find "${D}" -type d -name test | xargs rm -rf
}

src_install() {
	python_foreach_impl hawkey_src_install_internal
}
