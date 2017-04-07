# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# this changes for every release
LINK_PREFIX=4109

DESCRIPTION="Tool to handle local repositories of Debian packages"
HOMEPAGE="http://mirrorer.alioth.debian.org/"
SRC_URI="https://alioth.debian.org/frs/download.php/file/${LINK_PREFIX}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gpg"

CDEPEND="app-arch/bzip2
	app-arch/lzma
	app-arch/libarchive
	gpg? ( app-crypt/gpgme dev-libs/libgpg-error )
	>=sys-libs/db-4.8:*
	sys-libs/zlib"

DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}
	gpg? ( app-crypt/pinentry[ncurses] )"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	econf \
		--with-libbz2=yes \
		--with-liblzma=yes \
		--with-libarchive=yes \
		$(use_with gpg libgpgme)
}
