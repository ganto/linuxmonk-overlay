# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit cmake-utils python-r1

DESCRIPTION="Repodata downloading library"
HOMEPAGE="https://github.com/rpm-software-management/librepo"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test zchunk"

CDEPEND="app-crypt/gpgme
	>=dev-libs/glib-2.26.0
	dev-libs/expat
	dev-libs/libxml2
	dev-libs/openssl:0
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/pygpgme[${PYTHON_USEDEP}]
	dev-python/pyxattr[${PYTHON_USEDEP}]
	>=net-misc/curl-7.28.0
	sys-apps/attr
	zchunk? ( >=app-arch/zchunk-0.9.11 )
"
DEPEND="${CDEPEND}
	dev-libs/check
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		app-doc/doxygen
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	virtual/pkgconfig
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RDEPEND="${CDEPEND}"

src_prepare() {
	eapply_user

	# adjust python-3 specific tool names
	sed -i 's/nosetests${NOSETEST_VERSION_SUFFIX}/nosetests/' tests/python/tests/run_nosetests.sh.in

	cmake-utils_src_prepare
}

librepo_src_configure_internal() {
	local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
	mycmakeargs=(
		-DWITH_ZCHUNK=$(usex zchunk)
		-DPYTHON_DESIRED=${python_major}
	)
	cmake-utils_src_configure
}

src_configure() {
	python_foreach_impl librepo_src_configure_internal
}

librepo_src_compile_internal() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc
}

src_compile() {
	python_foreach_impl librepo_src_compile_internal
}

src_test() {
	librepo_src_test() {
		cd "${BUILD_DIR}"
		# When PORTAGE_TMPDIR is on a tmpfs the 'test_main' will fail with
		#     tests/test_checksum.c:148:F:Main:test_cached_checksum:0:
		#     Failure 'attr_ret == -1' occurred
		# because the test is trying to verify a user xattr which is not
		# supported on tmpfs. See rpm-software-management/librepo#119
		emake ARGS="-V" test
	}
	python_foreach_impl librepo_src_test
}

librepo_src_install_internal() {
	cmake-utils_src_install
	if use doc ; then
		dohtml -r -p python "${BUILD_DIR}"/doc/python/*
		dohtml -r -p c "${BUILD_DIR}"/doc/c/html/*
	fi
}

src_install() {
	python_foreach_impl librepo_src_install_internal
}
