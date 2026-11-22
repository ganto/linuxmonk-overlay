# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="Headless server for the Orca coding agent IDE"
HOMEPAGE="https://orca.dev https://github.com/stablyai/orca"
SRC_URI="https://github.com/stablyai/orca/releases/download/v${PV}/orca-server-linux-x64.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/orca-server-${PV}-linux-x64"

LICENSE="MIT"
# Bundled Node.js and ripgrep
LICENSE+=" Apache-1.1 Apache-2.0 BlueOak-1.0.0 BSD BSD-2 || ( MIT Unlicense )"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="splitdebug strip"

QA_PREBUILT="opt/orca-server/*"

src_install() {
	dodir /opt/orca-server
	cp -a --no-preserve=ownership . "${ED}/opt/orca-server/" || die
	# orca-ide belongs to app-editors/orca-bin, orca to the GNOME screen reader
	dosym ../../opt/orca-server/bin/orca-ide /usr/bin/orca-server

	# System-wide, unlike the orca-serve.service that Orca writes into ~/.config
	systemd_douserunit "${FILESDIR}"/orca-server.service
}

pkg_postinst() {
	elog "Enable it with 'systemctl --user enable --now orca-server'."
	elog
	elog "A running server keeps the old version until it is restarted."
	elog "Run 'systemctl --user restart orca-server' as the service user to load the new one."
}
