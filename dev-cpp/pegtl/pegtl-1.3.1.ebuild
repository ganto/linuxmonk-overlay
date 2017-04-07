# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Parsing Expression Grammar Template Library for C++11"
HOMEPAGE="http://www.developerfusion.com/project/35050/pegtl/"
SRC_URI="https://github.com/ColinH/PEGTL/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P^^}"

src_install() {
	doheader pegtl.hh

	insinto /usr/include
	doins -r pegtl

	dodoc README.md examples/*
}
