# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit systemd

DESCRIPTION="Update script for uncritical package updates"
HOMEPAGE="https://github.com/ganto/linuxmonk-overlay"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

DEPEND=""
RDEPEND=""

# avoid error that source directory doesn't exist
S="${WORKDIR}"

src_install() {
	exeinto /usr/sbin
	newexe "${FILESDIR}"/${PN}.sh checkupdate

	if use systemd; then
		systemd_dounit "${FILESDIR}"/checkupdate.service
		systemd_dounit "${FILESDIR}"/checkupdate.timer
	fi
}
