# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake python-r1

DESCRIPTION="Library providing simplified C and Python API to libsolv"
HOMEPAGE="https://github.com/rpm-software-management/libdnf"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="
	mirror
	!test? ( test )
"

LANGS=(
	as bg bn ca cs da de el es eu fa fi fil fr fur gu hi hu ia id is it ja ka kn ko mai ml
	mr nb nl or pa pl pt ru si sk sq sr sv ta te th tr uk
)
# localized help versions are installed only, when L10N var is set
for i in "${LANGS[@]}" ; do
	IUSE="${IUSE} l10n_${i}"
done

DEPEND="
	dev-db/sqlite
	>=dev-libs/glib-2.46.0
	dev-libs/json-c:=
	dev-libs/openssl
	sys-apps/util-linux

	>=app-arch/rpm-4.15.0:=
	>=app-arch/zchunk-0.9.11
	>=sys-libs/libmodulemd-2.13.0
	>=sys-libs/librepo-1.15.0[gpgme(+)]
	>=dev-libs/libsolv-0.7.21[python,${PYTHON_USEDEP},rpm]
"
RDEPEND="${PYTHON_DEPS}
	${DEPEND}
"
BDEPEND="
	>=dev-lang/swig-3.0.12
	dev-libs/check
	dev-util/cppunit
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	eapply_user

	# adjust python-3 specific tool names
	sed -i 's/sphinx-build-3/sphinx-build/' docs/hawkey/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	libdnf_src_configure_internal() {
		local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
		mycmakeargs=(
			-DPYTHON_DESIRED:str=${python_major}
			-DWITH_GTKDOC=OFF
			-DWITH_HTML=OFF
			-DWITH_MAN=OFF
			-DWITH_ZCHUNK=ON
			-Wno-dev
		)
		cmake_src_configure
	}
	python_foreach_impl libdnf_src_configure_internal
}

src_compile() {
	python_foreach_impl cmake_src_compile
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
		cmake_src_install
		python_optimize "${D}"/$(python_get_sitedir)/${PN}
		python_optimize "${D}"/$(python_get_sitedir)/hawkey
	}
	python_foreach_impl libdnf_src_install_internal

	# clean unneeded language documentation
	rm -rf "${ED}"/usr/share/locale/{bn_IN,pt_BR,sr@latin,zh_CN,zh_TW}
	for i in ${LANGS[@]}; do
		use l10n_${i} || rm -rf "${ED}"/usr/share/locale/${i/-/_}
	done

	# remove locale directory when empty
	rmdir "${ED}"/usr/share/locale 2>/dev/null
}
