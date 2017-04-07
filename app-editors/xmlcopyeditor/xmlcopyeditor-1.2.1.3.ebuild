# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

WX_GTK_VER="2.8"

inherit autotools wxwidgets

DESCRIPTION="XML Copy Editor is a fast, free, validating XML editor"
HOMEPAGE="http://xml-copy-editor.sourceforge.net/"
SRC_URI="mirror://sourceforge/xml-copy-editor/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.7.3-r1
	dev-libs/libxslt
	dev-libs/xerces-c[icu]
	dev-libs/libpcre
	app-text/aspell
	x11-libs/wxGTK:2.8[X]"
DEPEND="${RDEPEND}
	dev-libs/boost"

DOCS=( AUTHORS ChangeLog README NEWS )

src_prepare() {
	# fix desktop file
	sed -i  -e '/Categories/s/Application;//' \
		-e '/Icon/s/.png//' \
		-e 's/\r//g' \
		"data/${PN}.desktop.in" || die "sed on src/${PN}.desktop failed"

	# bug #440744
	sed -i  -e 's/ -Wall -g -fexceptions//g' \
		-e '/CXXFLAGS/s/CPPFLAGS/CXXFLAGS/' \
		configure.ac || die 'sed on configure.ac failed'
	eautoreconf
}
