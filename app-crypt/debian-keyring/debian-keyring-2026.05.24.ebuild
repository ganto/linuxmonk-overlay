# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="GnuPG archive keys of Debian Developers and Maintainers"
HOMEPAGE="https://packages.debian.org/sid/debian-keyring"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}_all.deb"

S="${WORKDIR}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	doins -r .
}
