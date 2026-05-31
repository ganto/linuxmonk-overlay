# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

MY_PN="${PN%-bin}"

DESCRIPTION="Fast JavaScript runtime, bundler, test runner, and package manager"
HOMEPAGE="https://bun.sh https://github.com/oven-sh/bun"
SRC_URI="
	amd64? ( https://github.com/oven-sh/bun/releases/download/${MY_PN}-v${PV}/${MY_PN}-linux-x64.zip )
	arm64? ( https://github.com/oven-sh/bun/releases/download/${MY_PN}-v${PV}/${MY_PN}-linux-aarch64.zip )
	https://raw.githubusercontent.com/oven-sh/bun/${MY_PN}-v${PV}/LICENSE.md -> ${P}-LICENSE.md
"
S="${WORKDIR}"

# Bun is MIT; statically linked bundled libraries carry additional licenses.
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 GPL-2 IJG LGPL-2 LGPL-2.1 MIT openssl unicode ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="app-arch/unzip"

RESTRICT="strip"
QA_PREBUILT="usr/bin/bun"

src_install() {
	cd "${MY_PN}-linux-$(usex amd64 x64 aarch64)" || die

	dobin "${MY_PN}"
	dosym "${MY_PN}" /usr/bin/bunx

	./bun completions bash > "${MY_PN}.bash" || die
	newbashcomp "${MY_PN}.bash" "${MY_PN}"

	newdoc "${DISTDIR}/${P}-LICENSE.md" LICENSE.md
}
