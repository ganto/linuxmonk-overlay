# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Server for the T3 Code coding agent GUI"
HOMEPAGE="https://t3.codes"
SRC_URI="https://github.com/pingdotgg/t3code/releases/download/v${PV}/t3-${PV}-linux-x64.tar.gz"
S="${WORKDIR}/t3-${PV}-linux-x64"

# libatomic is bundled in lib/
LICENSE="MIT GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="splitdebug strip"

QA_PREBUILT="opt/t3code/*"

src_prepare() {
	default
	# Only glibc is supported here
	rm -r \
		node_modules/@ff-labs/fff-bin-linux-x64-musl \
		node_modules/@koromix/koffi-linux-x64/musl_x64 \
		node_modules/@yuuang/ffi-rs-linux-x64-musl || die
}

src_install() {
	dodir /opt/t3code
	cp -a --no-preserve=ownership . "${ED}/opt/t3code/" || die
	dosym ../../opt/t3code/t3 /usr/bin/t3
}

pkg_postinst() {
	elog "A running server keeps the old version until it is restarted."
	elog "Run 't3 service restart' as the service user to load the new one."
}
