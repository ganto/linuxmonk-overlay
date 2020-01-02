# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit cmake-utils python-r1

DESCRIPTION="Library providing simplified C and Python API to libsolv"
HOMEPAGE="https://github.com/rpm-software-management/libdnf"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	app-crypt/gpgme
	dev-db/sqlite
	>=dev-libs/glib-2.46.0
	dev-libs/json-c
	dev-libs/openssl
	sys-apps/util-linux

	>=app-arch/rpm-4.11.0
	>=app-arch/zchunk-0.9.11
	>=sys-libs/libmodulemd-1.6.1:0
	>=sys-libs/librepo-1.11.0
	>=dev-libs/libsolv-0.7.7[python,${PYTHON_USEDEP}]
"
RDEPEND="${PYTHON_DEPS}
	${DEPEND}
"
BDEPEND="
	>=dev-lang/swig-3.0.12
	dev-libs/check
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-util/cppunit )
"

PATCHES=( "${FILESDIR}"/${PV}-Fix-use-with-src-in-hy_subject_get_best_solution.patch )

src_prepare() {
	eapply_user

	# adjust python-3 specific tool names
	sed -i 's/sphinx-build-3/sphinx-build/' docs/hawkey/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	libdnf_src_configure_internal() {
		local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
		mycmakeargs=(
			-DDISABLE_VALGRIND=1
			-DPYTHON_DESIRED:str=${python_major}
			-DWITH_GTKDOC=OFF
			-DWITH_HTML=OFF
			-DWITH_MAN=OFF
			-DWITH_ZCHUNK=ON
		)
		cmake-utils_src_configure
	}
	python_foreach_impl libdnf_src_configure_internal
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	libdnf_src_test_internal() {
		cd "${BUILD_DIR}"
		tests/run_tests || die "Tests failed under ${EPYTHON}"
	}
	python_foreach_impl libdnf_src_test_internal
}

src_install() {
	libdnf_src_install_internal() {
		cmake-utils_src_install
		python_optimize "${D}"/$(python_get_sitedir)/${PN}
		python_optimize "${D}"/$(python_get_sitedir)/hawkey
	}
	python_foreach_impl libdnf_src_install_internal
}
