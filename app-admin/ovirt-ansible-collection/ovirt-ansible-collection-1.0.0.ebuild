# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Ansible collection with all ovirt modules"
HOMEPAGE="https://galaxy.ansible.com/ovirt/ovirt"
SRC_URI="https://github.com/oVirt/${PN}/releases/download/${PV}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=app-admin/ansible-2.9
	>=dev-python/ovirt-engine-sdk-python-4.4
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	export PKG_DATA_DIR_ORIG=/usr/share/ansible/collections/ansible_collections/ovirt/ovirt
	export PKG_DATA_DIR="${ED}/${PKG_DATA_DIR_ORIG}"
	export PKG_DOC_DIR="${ED}/usr/share/doc/${PF}"
	sh build.sh install

	dodoc README.md
	dodoc -r examples
}
