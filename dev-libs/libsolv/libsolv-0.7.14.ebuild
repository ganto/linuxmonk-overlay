# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

USE_RUBY="ruby25 ruby26 ruby27"
RUBY_OPTIONAL=yes

inherit cmake-utils python-r1 ruby-ng perl-module multilib

DESCRIPTION="Library for solving packages and reading repositories"
HOMEPAGE="https://doc.opensuse.org/projects/libzypp/HEAD/ https://github.com/openSUSE/libsolv"
SRC_URI="https://github.com/openSUSE/libsolv/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bzip2 lzma perl python rpm ruby tcl zstd zchunk"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/expat
	dev-libs/libxml2
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	perl? ( dev-lang/perl:= )
	python? ( ${PYTHON_DEPS} )
	rpm? ( app-arch/rpm:= )
	ruby? ( $(ruby_implementations_depend) )
	tcl? ( dev-lang/tcl:0= )
	zchunk? ( app-arch/zchunk )
	zstd? ( app-arch/zstd )
"
DEPEND="${RDEPEND}
	perl? ( dev-lang/swig:0 )
	python? ( dev-lang/swig:0 )
	ruby? ( dev-lang/swig:0 )
	tcl? ( dev-lang/swig:0 )
	sys-devel/gettext
	virtual/pkgconfig
"

# The ruby-ng eclass is stupid and breaks this for no good reason.
S="${WORKDIR}/all/${P}"

pkg_setup() {
	use perl && perl_set_version
	use ruby && ruby-ng_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare

	# The python bindings are tightly integrated w/cmake.
	sed -i \
		-e 's: libsolvext libsolv: -lsolv:g' \
		bindings/python/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_APPDATA=1
		-DENABLE_ARCHREPO=ON
		-DENABLE_BZIP2_COMPRESSION=$(usex bzip2)
		-DENABLE_COMPLEX_DEPS=1
		-DENABLE_COMPS=1
		-DENABLE_DEBIAN=ON
		-DENABLE_HELIXREPO=ON
		-DENABLE_LZMA_COMPRESSION=$(usex lzma)
		-DENABLE_PERL=$(usex perl)
		-DENABLE_PYTHON=0
		-DENABLE_RPMDB=$(usex rpm)
		-DENABLE_RPMDB_BYRPMHEADER=$(usex rpm)
		-DENABLE_RPMDB_LIBRPM=$(usex rpm)
		-DENABLE_RPMPKG_LIBRPM=$(usex rpm)
		-DENABLE_RPMMD=$(usex rpm)
		-DENABLE_RUBY=$(usex ruby)
		-DENABLE_SUSEREPO=ON
		-DENABLE_TCL=$(usex tcl)
		-DENABLE_ZCHUNK_COMPRESSION=$(usex zchunk)
		-DENABLE_ZSTD_COMPRESSION=$(usex zstd)
		-DMULTI_SEMANTICS=ON
		-DUSE_VENDORDIRS=ON
		-DWITH_LIBXML2=ON
		-DWITH_SYSTEM_ZCHUNK=$(usex zchunk)
	)
	cmake-utils_src_configure

	if use python ; then
		# python_foreach_impl will create a unique BUILD_DIR for
		# us to run inside of, so no need to manage it ourselves.
		mycmakeargs+=(
			# Rework the bindings for a minor configure speedup.
			-DENABLE_PYTHON=1
			-DENABLE_{PERL,RUBY,TCL}=0
		)
		# Link against the common library so the bindings don't
		# have to rebuild it.
		LDFLAGS="-L${BUILD_DIR}/src ${LDFLAGS}" \
		python_foreach_impl cmake-utils_src_configure
	fi
}

pysolv_phase_func() {
	BUILD_DIR="${BUILD_DIR}/bindings/python" \
	cmake-utils_${EBUILD_PHASE_FUNC}
	if [[ "${EBUILD_PHASE_FUNC}" == "src_install" ]]; then
		python_optimize "${D}${PYTHON_SITEDIR}"
	fi
}

src_compile() {
	cmake-utils_src_compile

	use python && python_foreach_impl pysolv_phase_func
}

src_install() {
	cmake-utils_src_install

	use python && python_foreach_impl pysolv_phase_func
	use perl && perl_delete_localpod
}
