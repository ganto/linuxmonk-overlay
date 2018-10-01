# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN=github.com/imjoey/terraform-provider-ovirt
EGIT_COMMIT=v${PV}
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

inherit golang-vcs-snapshot golang-build

DESCRIPTION="Terraform provider for oVirt 4.x"
HOMEPAGE="https://github.com/imjoey/terraform-provider-ovirt"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	exeinto /usr/share/terraform/plugins
	doexe "${PN}"

	pushd src/${EGO_PN}
	dodoc CHANGELOG.md README.md
	dodoc -r examples
	popd
}
