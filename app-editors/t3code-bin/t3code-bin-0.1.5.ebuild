# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pax-utils unpacker xdg

DESCRIPTION="Desktop app for coding agents"
HOMEPAGE="https://t3.codes"
SRC_URI="https://github.com/pingdotgg/t3code/releases/download/v${PV}/T3-Code-${PV}-amd64.deb"
S="${WORKDIR}"

LICENSE="MIT"
# From www-client/chromium for the bundled Electron runtime
LICENSE+=" Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 Base64 Boost-1.0 CC-BY-3.0 CC-BY-4.0 Clear-BSD FFT2D FTL"
LICENSE+=" IJG ISC LGPL-2 LGPL-2.1 MIT MPL-1.1 MPL-2.0 Ms-PL PSF-2 SGI-B-2.0 SSLeay SunSoft Unicode-3.0"
LICENSE+=" Unicode-DFS-2015 Unlicense UoI-NCSA ZLIB libtiff openssl"
# From net-libs/nodejs
LICENSE+=" Apache-1.1 BlueOak-1.0.0"
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

QA_PREBUILT="opt/t3code/*"

src_prepare() {
	default
	mv "opt/T3 Code (Beta)" opt/t3code || die
	sed -e 's|^Exec="/opt/T3 Code (Beta)/t3code" %U$|Exec=t3code %U|' \
		-i usr/share/applications/t3code.desktop || die
	unpack usr/share/doc/t3code/changelog.gz

	# The installed package is neither an AppImage nor a deb, so updates are unavailable.
	rm opt/t3code/resources/{package-type,app-update.yml} || die
	rm opt/t3code/resources/apparmor-profile || die
	rm -r \
		opt/t3code/resources/app.asar.unpacked/node_modules/@ff-labs/fff-bin-linux-x64-musl \
		opt/t3code/resources/app.asar.unpacked/node_modules/@yuuang/ffi-rs-linux-x64-musl \
		opt/t3code/resources/app.asar.unpacked/node_modules/node-pty/prebuilds/linux-arm64 || die
}

src_install() {
	dodoc changelog
	dodir /opt
	cp -a --no-preserve=ownership opt/t3code "${ED}/opt/" || die
	insinto /usr/share
	doins -r usr/share/applications usr/share/icons usr/share/metainfo

	pax-mark m "${ED}/opt/t3code/t3code" "${ED}/opt/t3code/chrome-sandbox" \
		"${ED}/opt/t3code/chrome_crashpad_handler"
	fperms +x /opt/t3code/t3code /opt/t3code/chrome-sandbox /opt/t3code/chrome_crashpad_handler
	# Only needed when unprivileged user namespaces are unavailable
	use suid && fperms u+s /opt/t3code/chrome-sandbox

	dosym ../../opt/t3code/t3code /usr/bin/t3code
}
