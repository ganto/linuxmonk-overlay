# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit cmake-utils python-r1

DESCRIPTION="Repodata downloading library"
HOMEPAGE="https://github.com/rpm-software-management/librepo"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

CDEPEND="app-crypt/gpgme
	>=dev-libs/glib-2.26.0
	dev-libs/expat
	dev-libs/openssl:0
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/pygpgme[${PYTHON_USEDEP}]
	dev-python/pyxattr[${PYTHON_USEDEP}]
	>=net-misc/curl-7.19.0
	sys-apps/attr"

DEPEND="${CDEPEND}
	dev-libs/check
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	virtual/pkgconfig
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

RDEPEND="${CDEPEND}"

S="${WORKDIR}/librepo-${P}"

src_prepare() {
	# adjust python-3 specific tool names
	sed -i 's/nosetests${NOSETEST_VERSION_SUFFIX}/nosetests/' tests/python/tests/run_nosetests.sh.in
}

librepo_src_configure_internal() {
	local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
	mycmakeargs="${mycmakeargs} -DPYTHON_DESIRED=${python_major}"
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
	python_foreach_impl cmake-utils_src_test
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
