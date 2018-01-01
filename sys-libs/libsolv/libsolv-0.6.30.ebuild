# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

inherit cmake-utils perl-module python-r1 python-utils-r1 ruby-single eutils

DESCRIPTION="Package dependency solver"
HOMEPAGE="https://github.com/openSUSE/libsolv"
SRC_URI="https://github.com/openSUSE/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bzip2 +lzma perl python ruby"

CDEPEND="
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	dev-libs/expat
	sys-libs/db:=
	sys-libs/zlib
"
RDEPEND="${CDEPEND}
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )
"
DEPEND="${CDEPEND}
	perl? ( dev-perl/Module-Build )
	python? ( dev-lang/swig )
"

libsolv_src_configure_internal() {
	local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
	mycmakeargs+=( -DENABLE_PYTHON=1 -DPythonLibs_FIND_VERSION="${python_major}" -DPythonLibs_FIND_VERSION_MAJOR="${python_major}" )
	cmake-utils_src_configure
}

pkg_setup() {
	use perl && perl_set_version
}

src_configure() {
	local mycmakeargs=(
		"-DFEDORA=1"
		"-DENABLE_APPDATA=ON"
		"-DENABLE_ARCHREPO=1"
		"-DENABLE_COMPLEX_DEPS=1"
		"-DENABLE_COMPS=ON"
		"-DENABLE_DEBIAN=ON"
		"-DENABLE_HELIXREPO=ON"
		"-DENABLE_RPMDB=ON"
		"-DENABLE_RPMDB_BYRPMHEADER=ON"
		"-DENABLE_RPMMD=ON"
		"-DENABLE_SUSEREPO=ON"
		"-DMULTI_SEMANTICS=ON"
		"-DUSE_VENDORDIRS=ON"
	)
	use bzip2 && mycmakeargs+=( -DENABLE_BZIP2_COMPRESSION=1 )
	use lzma && mycmakeargs+=( -DENABLE_LZMA_COMPRESSION=1 )
	use perl && mycmakeargs+=( -DENABLE_PERL=1 )
	use ruby && mycmakeargs+=( -DENABLE_RUBY=1 )
	if use python; then
		python_foreach_impl libsolv_src_configure_internal
	else
		cmake-utils_src_configure
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl cmake-utils_src_compile
	else
		cmake-utils_src_compile
	fi
}

src_install() {
	if use python; then
		python_foreach_impl cmake-utils_src_install
	else
		cmake-utils_src_install
	fi
}
