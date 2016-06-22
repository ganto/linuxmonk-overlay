# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-app

DESCRIPTION="Entropy Gathering Daemon"
HOMEPAGE="http://egd.sourceforge.net/"
SRC_URI="http://prdownloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/perl-Digest-SHA"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/"${P}-ip-neigh.patch"
}
