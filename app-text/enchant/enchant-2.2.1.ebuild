# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

DESCRIPTION="Spellchecker wrapping library"
HOMEPAGE="https://abiword.github.io/enchant/"
SRC_URI="https://github.com/AbiWord/enchant/releases/download/v${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="~amd64"

IUSE="aspell +hunspell static-libs test"
REQUIRED_USE="|| ( hunspell aspell )"

# FIXME: depends on unittest++ but through pkgconfig which is a Debian hack, bug #629742
COMMON_DEPENDS="
	>=dev-libs/glib-2.6:2
	aspell? ( app-text/aspell )
	hunspell? ( >=app-text/hunspell-1.2.1:0= )"

RDEPEND="${COMMON_DEPENDS}"

DEPEND="${COMMON_DEPENDS}
	virtual/pkgconfig
"

RESTRICT="test"

src_configure() {
	econf \
		$(use_with aspell) \
		$(use_with hunspell) \
		$(use_enable static-libs static) \
		--without-hspell \
		--without-voikko \
		--with-hunspell-dir="${EPREFIX}"/usr/share/hunspell/
}

src_install() {
	default

	find "${D}" -name '*.la' -delete || die
}
