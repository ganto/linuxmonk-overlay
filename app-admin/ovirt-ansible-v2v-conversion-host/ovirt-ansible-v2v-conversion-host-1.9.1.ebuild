# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANSIBLE_ROLE_PREFIX=ovirt.
ANSIBLE_ROLE_NAME=v2v-conversion-host

DESCRIPTION="Ansible artifacts used for V2V oVirt/RHV Conversion Host"
HOMEPAGE="https://www.ovirt.org https://github.com/oVirt/ovirt-ansible-v2v-conversion-host"
SRC_URI="https://github.com/oVirt/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=app-admin/ansible-2.4"

S=${WORKDIR}

src_install() {
	export PKG_DATA_DIR="${ED}/usr/share/ansible/roles/${ANSIBLE_ROLE_PREFIX}${ANSIBLE_ROLE_NAME}"
	export PKG_DOC_DIR="${ED}/usr/share/doc/${PF}"
	export AUX_DATA_DIR="${ED}/usr/share/${PN}"
	sh build.sh install
	dodoc README.md
	dodoc -r examples docs
}
