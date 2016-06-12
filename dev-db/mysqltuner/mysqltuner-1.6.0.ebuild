# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="MySQLTuner is a high-performance MySQL tuning script"
HOMEPAGE="http://www.mysqltuner.com"
SRC_URI="https://github.com/major/MySQLTuner-perl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/perl-5.6
	virtual/perl-Getopt-Long
	>=virtual/mysql-5.5"

DOCS=( CONTRIBUTING.md INTERNALS.md README.md USAGE.md )

S="${WORKDIR}/MySQLTuner-perl-${PV}"

src_install() {
	mv "${PN}".pl "${PN}"
	dobin "${PN}"
	dodoc "${DOCS[@]}"
}
