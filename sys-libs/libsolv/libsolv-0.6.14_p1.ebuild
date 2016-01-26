# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
USE_RUBY="ruby20 ruby21 ruby22"

inherit cmake-utils perl-module python-r1 python-utils-r1 ruby-single eutils

MY_PV="${PV%%_*}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Package dependency solver"
HOMEPAGE="https://en.opensuse.org/openSUSE:Libzypp_satsolver"
SRC_URI="https://github.com/openSUSE/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bzip2 +lzma perl python ruby"

CDEPEND="bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	dev-libs/expat
	sys-libs/db
	sys-libs/zlib"

RDEPEND="perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	ruby? ( ${RUBY_DEPS} )"

DEPEND="${CDEPEND}
	perl? ( dev-perl/Module-Build )
	python? ( dev-lang/swig )"

S=${WORKDIR}/${MY_P}

libsolv_src_configure_internal() {
	local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
	mycmakeargs+=( -DENABLE_PYTHON=1 -DPythonLibs_FIND_VERSION="${python_major}" -DPythonLibs_FIND_VERSION_MAJOR="${python_major}" )
	cmake-utils_src_configure
}

pkg_setup() {
	use perl && perl_set_version
}

src_prepare() {
	epatch "${FILESDIR}/libsolv-0.6.14_Move-allowuninstall-map-creation.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_ruby-make-compatible-with-ruby-2.2.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_Drop-inline-from-solver_addtodupmaps.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_Prefer-to-autouninstall-orphans.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_Check-keep_orphans-flag-in-solver_addduprules.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_Rename-hasdupjobs-to-needduprules.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_Fix-spelling-duh.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_Fix-typo-in-comment.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_Speed-up-choice-rule-generation.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_Make-keep_orphans-also-keep-multiversion-orphans-ins.patch"
	epatch "${FILESDIR}/libsolv-0.6.14_Simplify-solver_addduprules-a-bit.patch"
}

src_configure() {
	local mycmakeargs=(
		"-DUSE_VENDORDIRS=1"
		"-DFEDORA=1"
		"-DENABLE_DEBIAN=1"
		"-DENABLE_ARCHREPO=1"
		"-DMULTI_SEMANTICS=1"
		"-DENABLE_COMPLEX_DEPS=1"
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
