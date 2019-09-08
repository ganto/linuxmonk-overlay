# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="Rocket.Chat"

inherit eutils rpm

DESCRIPTION="Rocket.Chat Desktop application"
HOMEPAGE="https://rocket.chat"

SRC_URI="https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/${PV}/rocketchat-${PV}.x86_64.rpm"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	gnome-base/gconf:2
	dev-libs/atk:0
	dev-libs/expat:0
	dev-libs/glib:2
	dev-libs/nspr:0
	dev-libs/nss:0
	gnome-base/gconf:2
	media-libs/alsa-lib:0
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	net-print/cups:0
	sys-apps/dbus:0
	sys-devel/gcc
	sys-libs/glibc:2.2
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11:0
	x11-libs/libxcb:0/1.12
	x11-libs/libXcomposite:0
	x11-libs/libXcursor:0
	x11-libs/libXdamage:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXi:0
	x11-libs/libXrandr:0
	x11-libs/libXrender:0
	x11-libs/libXScrnSaver:0
	x11-libs/libXtst:0
	x11-libs/pango:0"

S="${WORKDIR}"

QA_PREBUILT="
	opt/${MY_PN}/rocketchat-desktop
	opt/${MY_PN}/libnode.so
	opt/${MY_PN}/libffmpeg.so
"

DOCS=(
	"opt/${MY_PN}/LICENSES.chromium.html"
	"opt/${MY_PN}/LICENSE.electron.txt"
)

src_install() {
	insinto "/opt/${MY_PN}/locales"
	doins "opt/${MY_PN}/locales"/*.pak

	insinto "/opt/${MY_PN}/resources"
	doins "opt/${MY_PN}/resources"/*.asar
	insinto "/opt/${MY_PN}/resources/dictionaries"
	doins "opt/${MY_PN}/resources/dictionaries"/*.aff "opt/${MY_PN}/resources/dictionaries"/*.dic

	insinto "/opt/${MY_PN}"
	doins "opt/${MY_PN}"/*.pak "opt/${MY_PN}"/*.bin "opt/${MY_PN}"/*.dat
	exeinto "/opt/${MY_PN}"
	doexe "opt/${MY_PN}"/*.so "opt/${MY_PN}/rocketchat-desktop"

	dosym "../../opt/${MY_PN}/rocketchat-desktop" "/usr/bin/rocketchat-desktop"

	newicon "${S}/usr/share/icons/hicolor/512x512/apps/rocketchat-desktop.png" "rocketchat-desktop.png"
	make_desktop_entry rocketchat-desktop "${MY_PN}" rocketchat-desktop

	einstalldocs
}
