# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P}-1"

DESCRIPTION="Collection of GPG keys used in Linux distributions"
HOMEPAGE="https://github.com/rpm-software-management/distribution-gpg-keys"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="copr"
RESTRICT="mirror"

DOCS=( README.md SOURCES.md )

src_prepare() {
	default
	use copr || rm -rf keys/copr || die
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r keys/*
}
