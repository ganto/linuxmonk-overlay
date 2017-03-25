# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Collection of GPG keys used in Linux distributions"
HOMEPAGE="https://github.com/xsuchy/distribution-gpg-keys"
SRC_URI="https://github.com/xsuchy/${PN}/archive/${P}-1.tar.gz"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="copr"

DOCS=( README.md SOURCES.md )

S="${WORKDIR}/distribution-gpg-keys-${P}-1"

src_install() {
	default

	insinto /usr/share/${PN}
	if use copr ; then
		doins -r keys/*
	else
		doins -r keys/{centos,epel,fedora,mageia,redhat,rpmfusion}
	fi
}
