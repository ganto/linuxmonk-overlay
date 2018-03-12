# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils prefix

DESCRIPTION="rpm workalike for Gentoo Linux"
HOMEPAGE="https://github.com/fuzzyray/epm"
SRC_URI="https://raw.githubusercontent.com/fuzzyray/epm/0d3bc678ef03dca7669eddbbba77509b0ebacdf9/epm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=">=dev-lang/perl-5"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir "${S}"
	cp "${DISTDIR}/epm" "${S}"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-prefix.patch
	eprefixify epm
}

src_compile() {
	pod2man epm > epm.1 || die "pod2man failed"
}

src_install() {
	dobin epm || die
	doman epm.1
}
