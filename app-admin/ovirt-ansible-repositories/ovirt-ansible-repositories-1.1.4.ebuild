# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANSIBLE_ROLE_PREFIX=ovirt.
ANSIBLE_ROLE_NAME=repositories

DESCRIPTION="Ansible to setup the repositories required for oVirt engine or host installation"

HOMEPAGE="https://www.ovirt.org https://github.com/oVirt/ovirt-ansible-repositories"
SRC_URI="https://github.com/oVirt/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=app-admin/ansible-2.7.2"

PATCHES=( "${FILESDIR}"/${P}-Add-4.3-repositories.patch )

S=${WORKDIR}

src_install() {
	export PKG_DATA_DIR="${ED}/usr/share/ansible/roles/${ANSIBLE_ROLE_PREFIX}${ANSIBLE_ROLE_NAME}"
	export PKG_DOC_DIR="${ED}/usr/share/doc/${PF}"
	export ROLENAME_LEGACY_UPPERCASE="${ED}/usr/share/ansible/roles/oVirt.${ANSIBLE_ROLE_NAME}"
	sh build.sh install
	dodoc README.md
	dodoc -r examples
}
