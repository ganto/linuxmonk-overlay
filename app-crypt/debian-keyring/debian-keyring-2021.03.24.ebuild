# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="GnuPG archive keys of Debian Developers and Maintainers"
HOMEPAGE="https://packages.debian.org/sid/debian-keyring"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}_all.deb"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	doins -r .
}
