# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

MY_PN="CoreFreq"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="CoreFreq is a CPU monitoring software"
HOMEPAGE="https://github.com/cyring/CoreFreq"
SRC_URI="https://github.com/cyring/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${MY_P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+modules"

DEPEND="virtual/os-headers"
PDEPEND="
	modules? ( sys-apps/corefreq-kmod )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	emake corefreq-cli corefreqd
}

src_install() {
	dobin corefreq-cli corefreqd
	systemd_dounit corefreqd.service
	dodoc README.md
}
