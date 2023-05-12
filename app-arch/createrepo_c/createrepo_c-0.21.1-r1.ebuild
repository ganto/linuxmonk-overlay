# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit cmake python-r1

DESCRIPTION="C implementation of createrepo"
HOMEPAGE="https://rpm-software-management.github.io/createrepo_c"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc drpm legacyhashes python modulemd test zchunk"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	>=app-arch/rpm-4.9.0:=
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-libs/libxml2
	dev-libs/openssl:=
	net-misc/curl
	sys-apps/file
	sys-libs/zlib:=
	drpm? ( >=app-arch/drpm-0.4.0 )
	modulemd? ( >=sys-libs/libmodulemd-2.3 )
	zchunk? ( app-arch/zchunk )
"
RDEPEND="
	python? ( ${PYTHON_DEPS} )
	${DEPEND}
"
BDEPEND="
	doc? (
		app-doc/doxygen
		$(python_gen_any_dep 'dev-python/sphinx[${PYTHON_USEDEP}]')
	)
	test? ( ${RDEPEND} )
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]"
}

src_configure() {
	createrepo_c_src_configure_internal() {
		local mycmakeargs=(
			-DENABLE_DRPM=$(usex drpm)
			-DENABLE_PYTHON=ON
			-DWITH_LEGACY_HASHES=$(usex legacyhashes)
			-DWITH_LIBMODULEMD=$(usex modulemd)
			-DWITH_ZCHUNK=$(usex zchunk)
			-Wno-dev
		)
		cmake_src_configure
	}

	if use python; then
		python_foreach_impl createrepo_c_src_configure_internal
	else
		local mycmakeargs=(
			-DENABLE_DRPM=$(usex drpm)
			-DENABLE_PYTHON=OFF
			-DWITH_LEGACY_HASHES=$(usex legacyhashes)
			-DWITH_LIBMODULEMD=$(usex modulemd)
			-DWITH_ZCHUNK=$(usex zchunk)
			-Wno-dev
		)
		cmake_src_configure
	fi
}

src_compile() {

	if use python; then
		python_foreach_impl run_in_build_dir cmake_src_compile
	else
		cmake_src_compile
	fi

	if use doc; then
		if use python; then
			_python_obtain_impls
			multibuild_for_best_variant cmake_src_compile doc-c
		else
			cmake_src_compile doc-c
		fi
	fi

	if use test; then
		if use python; then
			_python_obtain_impls
			multibuild_for_best_variant cmake_src_compile tests
		else
			cmake_src_compile tests
		fi
	fi
}

src_test() {
	if use python; then
		_python_obtain_impls
		python_foreach_impl run_in_build_dir cmake_src_test
	else
		cmake_src_test
	fi
}

src_install() {
	createrepo_c_src_install_internal() {
		cmake_src_install
		python_optimize "${D}$(python_get_sitedir)/${PN}"
	}

	if use python; then
		python_foreach_impl run_in_build_dir createrepo_c_src_install_internal
	else
		cmake_src_install
	fi

	createrepo_c_einstalldoc_internal() {
		local HTML_DOCS=( "${BUILD_DIR}"/doc/html/. )
		einstalldocs
	}

	if use doc; then
		if python; then
			_python_obtain_impls
			multibuild_for_best_variant createrepo_c_einstalldoc_internal
		else
			createrepo_c_einstalldoc_internal
		fi
	fi
}
