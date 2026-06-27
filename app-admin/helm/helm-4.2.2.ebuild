# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module toolchain-funcs shell-completion

GIT_COMMIT=b05881cf967a5a09e19866799d0edfd40675803a

DESCRIPTION="Kubernetes Package Manager"
HOMEPAGE="https://helm.sh https://github.com/helm/helm"
SRC_URI="https://github.com/helm/helm/archive/v${PV}.tar.gz -> k8s-${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-golang-dist/${PN}/releases/download/v${PV}/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
# Dependent licenses
LICENSE+=" Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

BDEPEND=">=dev-lang/go-1.26.0"

src_compile() {
	local ldflags=(
		-X "helm.sh/helm/v4/internal/version.version=v${PV}"
		-X "helm.sh/helm/v4/internal/version.gitCommit=${GIT_COMMIT}"
		-X "helm.sh/helm/v4/internal/version.gitTreeState=clean"
	)
	mkdir -p bin || die
	go build ${GOFLAGS} -trimpath -ldflags "${ldflags[*]}" \
		-o bin/${PN} ./cmd/helm || die

	if ! tc-is-cross-compiler; then
		einfo "generating shell completion files"
		bin/${PN} completion bash > ${PN}.bash || die
		bin/${PN} completion zsh > ${PN}.zsh || die
		bin/${PN} completion fish > ${PN}.fish || die
	fi
}

src_install() {
	dobin bin/${PN}
	einstalldocs

	if ! tc-is-cross-compiler; then
		newbashcomp ${PN}.bash ${PN}
		newzshcomp ${PN}.zsh _${PN}
		dofishcomp ${PN}.fish
	else
		ewarn "Shell completion files not installed! Install them manually with '${PN} completion --help'"
	fi
}
