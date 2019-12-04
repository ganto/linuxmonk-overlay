# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg-utils

MY_PN=osmc
MY_PV=${PV}-1
MY_P=${MY_PN}-${MY_PV}

DESCRIPTION="Installer for the OSMC media center distribution"
HOMEPAGE="https://osmc.tv"
SRC_URI="https://github.com/osmc/${MY_PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5[jpeg,png]
	>=x11-libs/libX11-1.4.99.1
"
RDEPEND="${DEPEND}
	app-admin/sudo
	sys-apps/util-linux
	sys-block/parted
"
BDEPEND="
	app-arch/gzip
	app-arch/tar
"

S="${WORKDIR}/${MY_P}/src"

src_unpack() {
	tar --no-same-owner -xzf "${DISTDIR}/${A}" "${MY_P}"/installer/host || die "unpack installer sources failed"

	pushd "${MY_P}" >/dev/null || die "failed to change to source directory"
	eapply "${FILESDIR}"/${PV}-Fix-partprobe-executable-path.patch

	pushd installer/host >/dev/null || die "failed to change to installer directory"
	einfo "Assembling installer archive"
	emake obs || die "make installer archive failed"
	popd >/dev/null; popd >/dev/null

	pwd
	einfo "Unpacking installer achive"
	tar -C "${MY_P}" --no-same-owner -xzf "${MY_P}"/installer/host/obs/src.tar.gz || die "unpack installer archive failed"
}

src_configure() {
	eqmake5
}

src_install() {
	exeinto /usr/share/osmc
	doexe qt_host_installer
	doexe osmcinstaller
	dosym ../share/osmc/osmcinstaller /usr/bin/osmcinstaller

	insinto /usr/share/osmc
	doins icon.png

	domenu osmcinstaller.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
