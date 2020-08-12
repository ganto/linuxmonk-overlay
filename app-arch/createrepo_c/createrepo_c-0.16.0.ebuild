# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit cmake-utils python-r1 bash-completion-r1

DESCRIPTION="Creates a common metadata repository"
HOMEPAGE="http://rpm-software-management.github.io/createrepo_c/"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc modulemd test"
RESTRICT="!test? ( test )"

CDEPEND="
	app-arch/bzip2
	app-arch/drpm
	>=app-arch/rpm-4.9.0:=
	app-arch/xz-utils
	app-arch/zchunk
	dev-db/sqlite:3
	>=dev-libs/glib-2.22:2
	dev-libs/libxml2
	dev-libs/openssl:0
	net-misc/curl
	sys-apps/file
	sys-libs/zlib
	modulemd? ( >=sys-libs/libmodulemd-2.3:2 )
"
RDEPEND="
	${PYTHON_DEPS}
	${CDEPEND}
"
DEPEND="${CDEPEND}
	doc? (
		app-doc/doxygen
		$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
	)
	test? (
		dev-libs/check
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

python_check_deps() {
	has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

src_configure() {
	createrepo_c_src_configure_internal() {
		local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
		mycmakeargs=(
			-DPYTHON_DESIRED=${python_major}
			-DWITH_LIBMODULEMD=$(usex modulemd)
		)

		cmake-utils_src_configure
	}
	python_foreach_impl createrepo_c_src_configure_internal
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile

	if use doc; then
		python_setup
		cmake-utils_src_compile doc-c
	fi
	if use test; then
		python_setup
		cmake-utils_src_compile tests
	fi
}

src_test() {
	python_setup
	pushd "${BUILD_DIR}"
	tests/run_gtester.sh || die "Failed to run C unittests"
	popd

	# reset BUILD_DIR/CMAKE_BUILD_DIR, bug(?)
	createrepo_c_src_test_internal() {
		CMAKE_BUILD_DIR="${BUILD_DIR}" cmake-utils_src_test
	}
	BUILD_DIR="${S}" python_foreach_impl createrepo_c_src_test_internal
}

src_install() {
	# reset BUILD_DIR/CMAKE_BUILD_DIR, bug(?)
	createrepo_c_src_install_internal() {
		CMAKE_BUILD_DIR="${BUILD_DIR}" cmake-utils_src_install
		python_optimize "${D}$(python_get_sitedir)/${PN}"
	}
	BUILD_DIR="${S}" python_foreach_impl createrepo_c_src_install_internal

	if use doc; then
		python_setup
		local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
		einstalldocs
	fi
}
