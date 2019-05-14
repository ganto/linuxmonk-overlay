# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANSIBLE_ROLE_PREFIX=ovirt.
ANSIBLE_ROLE_NAME=hosted-engine-setup

DESCRIPTION="Ansible role for deploying oVirt Hosted-Engine"
HOMEPAGE="https://www.ovirt.org https://github.com/oVirt/ovirt-ansible-hosted-engine-setup"
SRC_URI="https://github.com/oVirt/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	>=app-admin/ansible-2.7
	>=app-admin/ovirt-ansible-engine-setup-1.1.5
	>=app-admin/ovirt-ansible-repositories-1.1.2
	dev-python/ovirt-engine-sdk-python
	dev-python/netaddr
"

S=${WORKDIR}

src_install() {
	export PKG_DATA_DIR="${ED}/usr/share/ansible/roles/${ANSIBLE_ROLE_PREFIX}${ANSIBLE_ROLE_NAME}"
	export PKG_DOC_DIR="${ED}/usr/share/doc/${PF}"
	export ROLENAME_LEGACY="${ED}/usr/share/ansible/roles/ovirt-${ANSIBLE_ROLE_NAME}"
	export ROLENAME_LEGACY_UPPERCASE="${ED}/usr/share/ansible/roles/oVirt.${ANSIBLE_ROLE_NAME}"
	sh build.sh install
	rm -r "${ED}/usr/share/ansible/roles/${ANSIBLE_ROLE_PREFIX}${ANSIBLE_ROLE_NAME}/examples"
	dodoc README.md
	dodoc -r examples
}
