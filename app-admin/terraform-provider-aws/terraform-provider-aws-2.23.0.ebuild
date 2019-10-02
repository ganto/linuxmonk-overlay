# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN=github.com/terraform-providers/terraform-provider-aws
EGIT_COMMIT=v${PV}
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

inherit golang-vcs-snapshot golang-build

DESCRIPTION="Terraform AWS Provider"
HOMEPAGE="https://www.terraform.io/docs/providers/aws"
LICENSE="MPL-2.0"
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
