# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Shell script to tell you if your Linux is vulnerable against Spectre/Meltdown"
HOMEPAGE="https://github.com/speed47/spectre-meltdown-checker"
SRC_URI="https://github.com/speed47/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	default
	dobin spectre-meltdown-checker.sh
}
