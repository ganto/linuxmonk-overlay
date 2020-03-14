# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WANT_AUTOCONF="2.1"

PYTHON_COMPAT=( python3_{6,7} )

LLVM_MAX_SLOT=10

inherit autotools llvm toolchain-funcs pax-utils mozcoreconf-v6

MY_PN="mozjs"
MY_P="${MY_PN}-${PV/_rc/.rc}"
MY_P="${MY_P/_pre/pre}"
DESCRIPTION="Stand-alone JavaScript C++ library"
HOMEPAGE="https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey"
SRC_URI="https://ftp.mozilla.org/pub/firefox/releases/${PV}esr/source/firefox-${PV}esr.source.tar.xz"

LICENSE="NPL-1.1"
SLOT="68"
KEYWORDS="~amd64"
IUSE="debug +jit minimal +system-icu test"

RESTRICT="!test? ( test )"

S="${WORKDIR}/firefox-${PV}"

BUILDDIR="${S}/jsobj"

RDEPEND=">=dev-libs/nspr-4.13.1
	dev-libs/libffi
	sys-libs/readline:0=
	>=sys-libs/zlib-1.2.3
	system-icu? ( >=dev-libs/icu-63.1:= )"
DEPEND="${RDEPEND}
	>=dev-lang/nasm-2.13
	sys-devel/llvm
	virtual/rust
"

pkg_setup(){
	[[ ${MERGE_TYPE} == "binary" ]] || \
		moz_pkgsetup
}

src_prepare() {
	eapply "${FILESDIR}"/moz68-build-Include-configure-script-be-nicer-about-option.patch

	# Patches from Gentoo patchset (spidermonkey-60.0-patches-04.tar.xz)
	eapply "${FILESDIR}"/0006-Ensure-we-fortify-properly-features.h-is-pulled-in-v.patch
	eapply "${FILESDIR}"/0007-set-pthread-name-for-non-glibc-systems.patch

	# Patches from Fedora mozjs68-68.6.0-1.fc33
	eapply "${FILESDIR}"/jstests_python-3.patch

	eapply_user

	# make sure we don't ever accidentally link against bundled security libs
	rm -rf security/

	# Remove zlib directory (to be sure using system version)
	rm -rf modules/zlib

	cd "${S}"/js/src || die
	eautoconf old-configure.in
	eautoconf

	# remove options that are not correct from js-config
	sed '/lib-filenames/d' -i "${S}"/js/src/build/js-config.in || die "failed to remove invalid option from js-config"

	# there is a default config.cache that messes everything up
	rm -f "${S}"/js/src/config.cache || die

	mkdir -p "${BUILDDIR}" || die
}

src_configure() {
	cd "${BUILDDIR}" || die

	ECONF_SOURCE="${S}/js/src" \
	econf \
		--enable-readline \
		--enable-shared-js \
		--with-system-nspr \
		--with-system-zlib \
		--disable-jemalloc \
		--disable-optimize \
		--with-intl-api \
		$(use_with system-icu) \
		$(use_enable debug) \
		$(use_enable test tests) \
		XARGS="/usr/bin/xargs" \
		SHELL="${SHELL:-${EPREFIX}/bin/bash}" \
		CC="${CC}" CXX="${CXX}" LD="${LD}" AR="${AR}" RANLIB="${RANLIB}"
}

cross_make() {
	emake \
		CFLAGS="${BUILD_CFLAGS}" \
		CXXFLAGS="${BUILD_CXXFLAGS}" \
		AR="${BUILD_AR}" \
		CC="${BUILD_CC}" \
		CXX="${BUILD_CXX}" \
		RANLIB="${BUILD_RANLIB}" \
		"$@"
}
src_compile() {
	cd "${BUILDDIR}" || die
	if tc-is-cross-compiler; then
		tc-export_build_env BUILD_{AR,CC,CXX,RANLIB}
		cross_make \
			MOZ_OPTIMIZE_FLAGS="" MOZ_DEBUG_FLAGS="" \
			HOST_OPTIMIZE_FLAGS="" MODULE_OPTIMIZE_FLAGS="" \
			MOZ_PGO_OPTIMIZE_FLAGS="" \
			host_jsoplengen host_jskwgen
		cross_make \
			MOZ_OPTIMIZE_FLAGS="" MOZ_DEBUG_FLAGS="" HOST_OPTIMIZE_FLAGS="" \
			-C config nsinstall
		mv {,native-}host_jskwgen || die
		mv {,native-}host_jsoplengen || die
		mv config/{,native-}nsinstall || die
		sed -i \
			-e 's@./host_jskwgen@./native-host_jskwgen@' \
			-e 's@./host_jsoplengen@./native-host_jsoplengen@' \
			Makefile || die
		sed -i -e 's@/nsinstall@/native-nsinstall@' config/config.mk || die
		rm -f config/host_nsinstall.o \
			config/host_pathsub.o \
			host_jskwgen.o \
			host_jsoplengen.o || die
	fi

	MOZ_MAKE_FLAGS="${MAKEOPTS}" \
	emake \
		MOZ_OPTIMIZE_FLAGS="" MOZ_DEBUG_FLAGS="" \
		HOST_OPTIMIZE_FLAGS="" MODULE_OPTIMIZE_FLAGS="" \
		MOZ_PGO_OPTIMIZE_FLAGS=""
}

src_test() {
	cd js/src || die
	PYTHONPATH=tests/lib ${PYTHON} tests/jstests.py -d -s -t 1800 --no-progress --wpt=disabled ../../jsobj/dist/bin/js || die
	PYTHONPATH=tests/lib ${PYTHON} jit-test/jit_test.py -s -t 1800 --no-progress ../../jsobj/dist/bin/js basic || die
}

src_install() {
	cd "${BUILDDIR}" || die
	emake DESTDIR="${D}" install

	if ! use minimal; then
		if use jit; then
			pax-mark m "${ED}"usr/bin/js${SLOT}
		fi
	else
		rm -f "${ED}"usr/bin/js${SLOT}
	fi

	# We can't actually disable building of static libraries
	# They're used by the tests and in a few other places
	find "${D}" -iname '*.a' -o -iname '*.ajs' -delete || die
}
