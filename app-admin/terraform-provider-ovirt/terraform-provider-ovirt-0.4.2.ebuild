# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN=github.com/ovirt/terraform-provider-ovirt
EGIT_COMMIT=v0.4.2
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

inherit golang-vcs-snapshot golang-build

DESCRIPTION="Terraform provider for oVirt 4.x"
HOMEPAGE="https://github.com/oVirt/terraform-provider-ovirt"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	dobin "${PN}"

	pushd src/${EGO_PN}
	dodoc CHANGELOG.md README.md
	dodoc -r examples
	popd
}
