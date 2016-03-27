# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="https://github.com/osmc/osmc.git"
EGIT_COMMIT="5d507efcb81fa9339bc338024da74019dab69bbb"

inherit qmake-utils git-r3

DESCRIPTION="Installer for the OSMC media center distribution"
HOMEPAGE="https://osmc.tv"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5[jpeg,png]
	>=x11-libs/libX11-1.4.99.1
"
RDEPEND="
	${DEPEND}
	sys-apps/util-linux
	sys-block/parted
"

S="${WORKDIR}/src"

PATCHES=( "${FILESDIR}/${PN}_fix-partprobe-executable-path.patch" )

src_unpack() {
	export EGIT_CHECKOUT_DIR="${T}/osmc"
	git-r3_src_unpack
	cd "${T}/osmc/installer/host"
	emake obs || die "make source archive failed"
	cd "${WORKDIR}"
	tar -xzf "${T}/osmc/installer/host/obs/src.tar.gz"
}

src_prepare() {
	epatch "${FILESDIR}/${P}_Fix-partprobe-executable-path.patch"
	epatch "${FILESDIR}/${P}_Define-QDataStream-include.patch"
}

src_configure() {
	eqmake5
}

src_install() {
	exeinto /usr/share/osmc
	doexe qt_host_installer
	doexe osmcinstaller
	dosym /usr/share/osmc/osmcinstaller /usr/bin/osmcinstaller

	insinto /usr/share/osmc
	doins icon.png

	domenu osmcinstaller.desktop
}
