# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Rocket.Chat"

inherit desktop eutils rpm xdg-utils

DESCRIPTION="Rocket.Chat Desktop application"
HOMEPAGE="https://rocket.chat"
SRC_URI="https://github.com/RocketChat/Rocket.Chat.Electron/releases/download/${PV}/rocketchat-${PV}.x86_64.rpm"

LICENSE="Apache-2.0 GPL-2+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror splitdebug test"
IUSE=""

RDEPEND="
	dev-libs/atk:0
	dev-libs/expat:0
	dev-libs/glib:2
	dev-libs/nspr:0
	dev-libs/nss:0
	media-libs/alsa-lib:0
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/mesa
	media-video/ffmpeg[chromium]
	net-print/cups:0
	sys-apps/dbus:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/libX11:0
	x11-libs/libxcb:0/1.12
	x11-libs/libXcomposite:0
	x11-libs/libXcursor:0
	x11-libs/libXdamage:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXi:0
	x11-libs/libxkbfile:0
	x11-libs/libXrandr:0
	x11-libs/libXrender:0
	x11-libs/libXScrnSaver:0
	x11-libs/libXtst:0
	x11-libs/pango:0"

S="${WORKDIR}"

QA_PREBUILT="
	opt/${MY_PN}/rocketchat-desktop
	opt/${MY_PN}/swiftshader/libvk_swiftshader.so
"

DOCS=(
	"opt/${MY_PN}/LICENSES.chromium.html"
	"opt/${MY_PN}/LICENSE.electron.txt"
)

src_install() {
	doins -r .
	rm -rf "${D}"/usr/lib/.build-id

	fperms +x /opt/${MY_PN}/rocketchat-desktop
	dosym "../../opt/${MY_PN}/rocketchat-desktop" "/usr/bin/rocketchat-desktop"

	# use system ffmpeg
	rm -f "${D}"/opt/${MY_PN}/libffmpeg.so || die

	cat > 99rocketchat-desktop <<-EOF
		LDPATH=${EROOT}/usr/$(get_libdir)/chromium
	EOF
	doenvd 99rocketchat-desktop

	# use system mesa
	rm -f "${D}"/opt/${MY_PN}/libEGL.so || die
	rm -f "${D}"/opt/${MY_PN}/libGLESv2.so || die
	rm -f "${D}"/opt/${MY_PN}/swiftshader/libEGL.so || die
	rm -f "${D}"/opt/${MY_PN}/swiftshader/libGLESv2.so || die

	domenu usr/share/applications/rocketchat-desktop.desktop

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
