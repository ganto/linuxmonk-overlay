# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-2

DESCRIPTION="Test WebDAV enabled servers by uploading test executable files"
HOMEPAGE="https://github.com/waltertamboer/davtest"
SRC_URI=""
EGIT_REPO_URI="https://github.com/waltertamboer/davtest.git"
EGIT_COMMIT="289825f63f484892ee932d37c468f97f6a232fce"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	dev-perl/HTTP-DAV
	virtual/perl-Getopt-Long
"

src_compile() {
	sed -i 's|\(tests/\)|/usr/share/davtest/\1|g' davtest.pl
	sed -i 's|\(backdoors/\)|/usr/share/davtest/\1|g' davtest.pl
}

src_install() {
	newbin davtest.pl davtest || die "install failed"

	dodir /usr/share/davtest
	insinto /usr/share/davtest
	doins -r tests backdoors || die

	dodoc README.txt || die
}
