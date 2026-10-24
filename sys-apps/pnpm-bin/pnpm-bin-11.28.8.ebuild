# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

DESCRIPTION="Fast, disk space efficient package manager, alternative to npm and yarn"
HOMEPAGE="https://pnpm.io"
MY_PN="pnpm"
SRC_URI="https://registry.npmjs.org/${MY_PN}/-/${MY_PN}-${PV}.tgz"
S="${WORKDIR}/package"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# pnpm ships a pre-bundled JS distribution; it is run by the system Node.js.
RDEPEND="
	>=net-libs/nodejs-22.13.1
	!net-libs/nodejs[corepack(-)]
	!!sys-apps/pnpm
"

# Pure JavaScript, nothing to strip; dist/node-gyp-bin ships helper scripts.
RESTRICT="strip"
QA_PREBUILT="usr/lib/node_modules/${MY_PN}/dist/node-gyp-bin/*"

src_prepare() {
	default

	# Remove non-Linux binaries, scripts, and prebuilt native modules
	find . \( -name "*.exe" -o -name "*.ps1" -o -name "*.cmd" -o -name "*.bat" \) -delete || die
	find . -name "*macOS*" -delete || die
	find dist/node_modules -maxdepth 2 -type d \( -name "*win32*" -o -name "*darwin*" \) -exec rm -r {} + || die
}

src_install() {
	local instdir="/usr/lib/node_modules/${MY_PN}"

	insinto "${instdir}"
	doins -r bin dist package.json

	# doins drops exec bits required by the entry points and node-gyp wrapper.
	fperms +x \
		"${instdir}/bin/pnpm.mjs" \
		"${instdir}/bin/pnpx.mjs" \
		"${instdir}/bin/pnpm.cjs" \
		"${instdir}/bin/pnpx.cjs" \
		"${instdir}/dist/node-gyp-bin/node-gyp"

	# Node resolves symlinks to their real path before resolving relative imports,
	# so the relative ../dist/ reference in bin/pnpm.mjs works correctly via symlink.
	dosym "../lib/node_modules/${MY_PN}/bin/pnpm.mjs" /usr/bin/pnpm
	dosym "../lib/node_modules/${MY_PN}/bin/pnpx.mjs" /usr/bin/pnpx
	dosym "../lib/node_modules/${MY_PN}/bin/pnpm.mjs" /usr/bin/pn
	dosym "../lib/node_modules/${MY_PN}/bin/pnpx.mjs" /usr/bin/pnx

	local shell
	for shell in bash zsh fish; do
		sed -e "s/{pkgname}/${MY_PN}/g" \
			-e "s|{completer}|/usr/bin/${MY_PN}|g" \
			"${S}/dist/templates/completion.${shell}" > "${T}/${MY_PN}.${shell}" || die
	done
	newbashcomp "${T}/${MY_PN}.bash" "${MY_PN}"
	newzshcomp "${T}/${MY_PN}.zsh" "_${MY_PN}"
	newfishcomp "${T}/${MY_PN}.fish" "${MY_PN}.fish"

	dodoc README.md
}
