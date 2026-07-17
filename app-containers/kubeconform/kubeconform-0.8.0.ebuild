# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Kubernetes manifest validation tool"
HOMEPAGE="https://github.com/yannh/kubeconform"
SRC_URI="https://github.com/yannh/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD imagemagick MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

BDEPEND=">=dev-lang/go-1.26:="

src_compile() {
	local -x CGO_ENABLED=0
	ego build -trimpath -ldflags "-X main.version=v${PV}" -o ${PN} ./cmd/${PN}
}

src_test() {
	ego test ./...
}

src_install() {
	dobin ${PN}
	dodoc Readme.md
}
