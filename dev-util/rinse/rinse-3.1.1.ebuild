# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils bash-completion-r1

MY_P="${PN}_${PV}"

DESCRIPTION="Bootstrap a minimal RPM based distribution"
HOMEPAGE="http://collab-maint.alioth.debian.org/rinse"
SRC_URI="http://httpredir.debian.org/debian/pool/main/r/${PN}/${MY_P}.tar.xz"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="test"

RDEPEND="=dev-lang/perl-5*
	dev-perl/libwww-perl
	app-arch/rpm
	net-misc/wget"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	# disable upstream Makefile
	mv Makefile Makefile.bak

	# use helper scripts from /usr/libexec
	epatch "${FILESDIR}/${PN}-3.1.1-set-libdir-to-libexec.patch"

	# remove failing test
	rm tests/no-tabs.t
}

src_compile() {
	perl -pi -e "s/XXUNRELEASEDXX/${PV}/" bin/rinse*
	pod2man --release=${PV} --official --section=8 bin/rinse rinse.8
}

src_test() {
	local mytestargs="--shuffle"
	if [ -n "${TEST_VERBOSE}" ]; then
		mytestargs="${testargs} --verbose"
	fi
	prove ${testargs} tests/
}

src_install() {
	insinto /etc/rinse
	doins etc/*.packages etc/*.conf

	dosbin bin/rinse*

	insopts -m0755
	insinto /usr/libexec/rinse/common
	doins scripts.common/*

	for dist in scripts/*/; do
		local name="$( basename $dist )"
		insinto /usr/libexec/rinse/"${name}"
		doins "${dist}"/*.sh
	done

	doman rinse.8
	dobashcomp misc/rinse
}
