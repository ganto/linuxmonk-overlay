# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module shell-completion

DESCRIPTION="TUI for reviewing diffs, files, and documents with inline annotations"
HOMEPAGE="https://github.com/umputun/revdiff"

SRC_URI="https://github.com/umputun/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT BSD ISC"

SLOT="0"
KEYWORDS="~amd64"
IUSE="+plugins"
RESTRICT="mirror strip"

PATCHES=( "${FILESDIR}/skip-git-vcs-detection-test.patch" )

BDEPEND=">=dev-lang/go-1.26:="

src_compile() {
	go build -v -o "${PN}" -ldflags="-s -w -X main.revision=v${PV}" ./app || die "compile failed"
}

src_test() {
	go test -timeout 120s ./... || die "tests failed"
}

src_install() {
	dobin "${PN}"
	dodoc CHANGELOG.md CONTRIBUTING.md README.md docs/ARCHITECTURE.md

	newbashcomp completions/revdiff.bash revdiff
	dofishcomp completions/revdiff.fish
	newzshcomp completions/revdiff.zsh _revdiff

	if use plugins; then
		insinto "/usr/share/${PN}/plugins"
		doins -r .claude-plugin plugins/codex plugins/opencode plugins/pi plugins/revdiff-planning
		mv "${ED}/usr/share/${PN}/plugins/.claude-plugin" "${ED}/usr/share/${PN}/plugins/claude" || die

		find "${ED}/usr/share/${PN}/plugins" -name "*.sh" -exec chmod +x {} + || die
	fi
}
