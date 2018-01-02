# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils python-r1

DESCRIPTION="Library providing simplified C and Python API to libsolv"
HOMEPAGE="https://github.com/rpm-software-management/libdnf"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="
	>=app-arch/rpm-4.11.0
	dev-libs/glib
	dev-libs/gobject-introspection
	sys-libs/librepo
	>=sys-libs/libsolv-0.6.21
"
DEPEND="${CDEPEND}
	dev-libs/check
	>=dev-util/gtk-doc-1.9
	virtual/pkgconfig
	test? ( dev-python/nose )
"
RDEPEND="${PYTHON_DEPS}
	${CDEPEND}
	!sys-libs/hawkey
"

src_prepare() {
	eapply_user

	# adjust python-3 specific tool names
	sed -i 's/sphinx-build-3/sphinx-build/' docs/hawkey/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	libdnf_src_configure_internal() {
		local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
		mycmakeargs=( -DPYTHON_DESIRED:str=${python_major} -DWITH_MAN=0 -DDISABLE_VALGRIND=1 )
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
		emake ARGS="-V" test || die "Tests failed under ${EPYTHON}"
	}
	python_foreach_impl libdnf_src_test_internal
}

src_install() {
	python_foreach_impl cmake-utils_src_install
}
