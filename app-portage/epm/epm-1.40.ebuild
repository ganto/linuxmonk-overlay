# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix

DESCRIPTION="rpm workalike for Gentoo Linux"
HOMEPAGE="https://github.com/fuzzyray/epm"
SRC_URI="https://raw.githubusercontent.com/fuzzyray/epm/0d3bc678ef03dca7669eddbbba77509b0ebacdf9/epm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/perl-5"
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir "${S}"
	cp "${DISTDIR}/epm" "${S}"
}

src_prepare() {
	eapply -p0 "${FILESDIR}"/${P}-prefix.patch
	default
	eprefixify epm
}

src_compile() {
	pod2man epm > epm.1 || die "pod2man failed"
}

src_install() {
	dobin epm || die
	doman epm.1
}
