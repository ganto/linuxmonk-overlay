# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANSIBLE_ROLE_PREFIX=ovirt.
ANSIBLE_ROLE_NAME=shutdown_env
ANSIBLE_ROLE_NAME_LEGACY=shutdown-env

DESCRIPTION="ovirt-ansible-shutdown-env Ansible role"
HOMEPAGE="https://www.ovirt.org https://github.com/oVirt/ovirt-ansible-shutdown-env"
SRC_URI="https://github.com/oVirt/${PN}/releases/download/${PV}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	>=app-admin/ansible-2.9.0
	>=dev-python/ovirt-engine-sdk-python-4.2
"
BDEPEND=""

S=${WORKDIR}

src_install() {
	export PKG_DATA_DIR="${ED}/usr/share/ansible/roles/${ANSIBLE_ROLE_PREFIX}${ANSIBLE_ROLE_NAME}"
	export PKG_DOC_DIR="${ED}/usr/share/doc/${PF}"
	export ROLENAME_LEGACY="${ED}/usr/share/ansible/roles/ovirt-${ANSIBLE_ROLE_NAME_LEGACY}"
	export ROLENAME_LEGACY_UPPERCASE="${ED}/usr/share/ansible/roles/oVirt.${ANSIBLE_ROLE_NAME_LEGACY}"
	sh build.sh install
	dodoc README.md
	dodoc -r examples
}
