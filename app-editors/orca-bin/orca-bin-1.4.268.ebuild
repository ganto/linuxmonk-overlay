# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils unpacker xdg

DESCRIPTION="IDE for running a fleet of parallel coding agents"
HOMEPAGE="https://orca.dev https://github.com/stablyai/orca"
SRC_URI="https://github.com/stablyai/orca/releases/download/v${PV}/orca-ide_${PV}_amd64.deb"
S="${WORKDIR}"

LICENSE="MIT"
# From www-client/chromium for the bundled Electron runtime
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Base64 Boost-1.0 CC-BY-3.0 CC-BY-4.0 Clear-BSD FFT2D FTL"
LICENSE+=" IJG ISC LGPL-2 LGPL-2.1 MIT MPL-1.1 MPL-2.0 Ms-PL PSF-2 SGI-B-2.0 SSLeay SunSoft Unicode-3.0"
LICENSE+=" Unicode-DFS-2015 Unlicense UoI-NCSA ZLIB libtiff openssl"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="suid"
RESTRICT="splitdebug"

RDEPEND="
	app-accessibility/at-spi2-core:2
	app-crypt/libsecret
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[opengl]
	net-print/cups
	sys-apps/dbus
	virtual/udev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/pango
	x11-misc/xdg-utils
"

QA_PREBUILT="opt/orca/*"

src_prepare() {
	default
	mv opt/Orca opt/orca || die
	sed -e 's|^Exec=/opt/Orca/orca-ide %U$|Exec=orca-ide %U|' \
		-e 's|^\(MimeType=.*\)x-scheme-handler/orca;x-scheme-handler/orca;$|\1x-scheme-handler/orca;|' \
		-i usr/share/applications/orca-ide.desktop || die
	unpack usr/share/doc/orca-ide/changelog.gz

	# The installed package is neither an AppImage nor a deb, so updates are unavailable.
	rm opt/orca/resources/{package-type,app-update.yml,apparmor-profile} || die
	rm -r opt/orca/resources/node_modules/@koromix/koffi-linux-x64/musl_x64 || die
}

src_install() {
	dodoc changelog
	dodir /opt
	cp -a --no-preserve=ownership opt/orca "${ED}/opt/" || die
	insinto /usr/share
	doins -r usr/share/applications usr/share/icons

	pax-mark m "${ED}/opt/orca/orca-ide" "${ED}/opt/orca/chrome-sandbox" \
		"${ED}/opt/orca/chrome_crashpad_handler"
	# Only needed when unprivileged user namespaces are unavailable
	use suid && fperms u+s /opt/orca/chrome-sandbox

	# Named orca-ide to avoid a clash with the GNOME screen reader (app-accessibility/orca)
	dosym ../../opt/orca/resources/bin/orca-ide /usr/bin/orca-ide
}
