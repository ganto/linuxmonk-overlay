# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}_${PV}"

DESCRIPTION="Bootstrap a minimal RPM based distribution"
HOMEPAGE="https://salsa.debian.org/debian/rinse"
SRC_URI="http://httpredir.debian.org/debian/pool/main/r/${PN}/${MY_P}.tar.xz"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	=dev-lang/perl-5*
	dev-perl/libwww-perl
	app-arch/rpm
	net-misc/wget
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-3.3-set-libdir-to-libexec.patch )

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	# remove failing test
	rm tests/no-tabs.t
}

src_test() {
	local mytestargs="--shuffle"
	if [ -n "${TEST_VERBOSE}" ]; then
		mytestargs="${testargs} --verbose"
	fi
	prove ${testargs} tests/
}
