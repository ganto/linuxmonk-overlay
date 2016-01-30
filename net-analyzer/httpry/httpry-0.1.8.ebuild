# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Specialized packet sniffer designed for displaying and logging HTTP traffic"
HOMEPAGE="http://dumpsterventures.com/jason/httpry"
SRC_URI="http://dumpsterventures.com/jason/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=net-libs/libpcap-1.1.1"
RDEPEND="${DEPEND}
	dev-lang/perl"

src_install() {
	dosbin ${PN}
	doman ${PN}.1

	exeinto /usr/libexec/${PN}
	doexe scripts/parse_log.pl
	insinto /usr/libexec/${PN}
	doins -r scripts/plugins

	dodoc doc/{AUTHORS,ChangeLog,format-string,method-string,perl-tools,README}
}
