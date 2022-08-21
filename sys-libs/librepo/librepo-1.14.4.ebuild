# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit cmake python-r1

DESCRIPTION="Repodata downloading library"
HOMEPAGE="https://github.com/rpm-software-management/librepo"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="doc test python zchunk"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="app-crypt/gpgme
	>=dev-libs/glib-2.28.0
	dev-libs/libxml2
	dev-libs/openssl:0
	>=net-misc/curl-7.52.0
	sys-apps/attr
	python? (
		app-crypt/gpgme[python,${PYTHON_USEDEP}]
		${PYTHON_DEPS}
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/pyxattr[${PYTHON_USEDEP}]
	)
	zchunk? ( >=app-arch/zchunk-0.9.11 )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/check
	doc? (
		app-doc/doxygen
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
	)
	virtual/pkgconfig
	test? (
		${RDEPEND}
		python? (
			dev-python/nose[${PYTHON_USEDEP}]
			dev-python/requests[${PYTHON_USEDEP}]
		)
	)
"

src_prepare() {
	cmake_src_prepare
	use python && python_copy_sources
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOCS=$(usex doc)
		-DENABLE_PYTHON=$(usex python)
		-DENABLE_TESTS=$(usex test)
		-DWITH_ZCHUNK=$(usex zchunk)
	)
	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_configure
	else
		cmake_src_configure
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_compile
		use doc && python_foreach_impl run_in_build_dir cmake_src_compile doc
	else
		cmake_src_compile
		use doc && cmake_src_compile doc
	fi
}

src_test() {
	# When PORTAGE_TMPDIR is on a tmpfs the 'test_main' will fail with
	#     tests/test_checksum.c:148:F:Main:test_cached_checksum:0:
	#     Failure 'attr_ret == -1' occurred
	# because the test is trying to verify a user xattr which is not
	# supported on tmpfs. See rpm-software-management/librepo#119
	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_test
	else
		sed -i '/subdirs("python")/d' "${BUILD_DIR}"/tests/CTestTestfile.cmake
		cmake_src_test
	fi
}

src_install() {
	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_install
		python_foreach_impl python_optimize
		if use doc; then
			python_setup
			doc_dir="${BUILD_DIR}-${EPYTHON/./_}"
			docinto html/python
			dodoc -r "${doc_dir}"/doc/python/.
		fi
	else
		cmake_src_install
		doc_dir="${BUILD_DIR}"
	fi
	if use doc; then
		docinto html/c
		dodoc -r "${doc_dir}"/doc/c/html/.
	fi
}
