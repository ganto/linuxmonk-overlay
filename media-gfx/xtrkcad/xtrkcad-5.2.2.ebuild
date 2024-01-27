# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg-utils

DESCRIPTION="CAD program for designing model railroad layouts"
HOMEPAGE="https://xtrkcad-fork.sourceforge.net"
if [[ ${PV} = 9999* ]]; then
	inherit mercurial
	EHG_REPO_URI="http://hg.code.sf.net/p/xtrkcad-fork/xtrkcad"
else
	#SRC_URI="https://sourceforge.net/projects/xtrkcad-fork/files/XTrackCad/Version%20${PV}/${PN}-source-${PV}GA.tar.bz2/download# -> ${PN}-source-${PV}GA.tar.bz2"
	SRC_URI="https://sourceforge.net/projects/xtrkcad-fork/files/XTrackCad/Version%20${PV}/${PN}-source-${PV}GA.tar.gz"
	S="${WORKDIR}/${PN}-source-${PV}GA"
	PATCHES=( "${FILESDIR}"/xtrkcad-5.2.2GA-xtrkcad.desktop.patch )
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

CDEPEND="
	dev-libs/cJSON
	dev-libs/libzip
	media-libs/freeimage
	sys-devel/gettext
	sys-libs/zlib
	x11-libs/gtk+:2
"
DEPEND="${CDEPEND}"
RDEPEND="${CDEPEND}"
BDEPEND="
	${CDEPEND}
	dev-util/desktop-file-utils
	doc? ( app-text/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DXTRKCAD_USE_DOXYGEN=$(usex doc)
		-Wno-dev
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm -f "${ED}"/usr/share/xtrkcad/pixmaps/xtrkcad.png
	doicon app/lib/xtrkcad.png

	mv "${ED}"/usr/share/xtrkcad/applications/xtrkcad.desktop "${T}"
	domenu "${T}"/xtrkcad.desktop

	rm -f "${ED}"/usr/share/xtrkcad/applications/xtrkcad.xml
	insinto /usr/share/mime/packages
	doins app/lib/xtrkcad.xml
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
