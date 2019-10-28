# Copyright 1999-2019 Gentoo Authors
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

CDEPEND="
	>=app-arch/rpm-4.11.0
	>=app-arch/zchunk-0.9.11
	dev-db/sqlite
	>=dev-libs/glib-2.46.0
	dev-libs/gobject-introspection
	dev-libs/json-c
	sys-apps/util-linux
	>=sys-libs/libmodulemd-1.6.1:0
	>=sys-libs/librepo-1.10.0
	>=dev-libs/libsolv-0.7.4[python,${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}
	>=dev-lang/swig-3.0.12
	dev-libs/check
	>=dev-util/gtk-doc-1.9
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-python/nose )
"
RDEPEND="${PYTHON_DEPS}
	${CDEPEND}
	!sys-libs/hawkey
"
PATCHES=(
	"${FILESDIR}"/0.31.0-0001-Revert-9309e92332241ff1113433057c969cebf127734e.patch
	# revert setting os-dependent user agent for client counting
	"${FILESDIR}"/${PV}-0003-Revert-countme.patch
	"${FILESDIR}"/${PV}-0004-Fix-leaking-log-handlers-in-Sack.patch
	"${FILESDIR}"/${PV}-0001-Add-module-reset-function-into-dnf_context.patch
	"${FILESDIR}"/${PV}-0001-Make-changes-in-dnf_context_reset_modules-permanent.patch
	# fix build against rpm <=4.15.0
	"${FILESDIR}"/${PV}-Define-RPMTAG_MODULARITYLABEL-if-rpm-doesnt-define-it.patch
)

src_prepare() {
	eapply_user

	# adjust python-3 specific tool names
	sed -i 's/sphinx-build-3/sphinx-build/' docs/hawkey/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	libdnf_src_configure_internal() {
		local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
		mycmakeargs=( -DPYTHON_DESIRED:str=${python_major} -DWITH_MAN=OFF -DDISABLE_VALGRIND=1 -DWITH_ZCHUNK=ON )
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
