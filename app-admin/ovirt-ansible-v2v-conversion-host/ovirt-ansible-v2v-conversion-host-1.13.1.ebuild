# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ANSIBLE_ROLE_PREFIX=ovirt.
ANSIBLE_ROLE_NAME=v2v-conversion-host

DESCRIPTION="Ansible artifacts used for V2V oVirt/RHV Conversion Host"
HOMEPAGE="https://www.ovirt.org https://github.com/oVirt/ovirt-ansible-v2v-conversion-host"
SRC_URI="https://github.com/oVirt/${PN}/releases/download/v${PV}/${ANSIBLE_ROLE_NAME}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	>=app-admin/ansible-2.4
	dev-python/ovirt-engine-sdk-python
	dev-python/pycurl[python_targets_python2_7]
	dev-python/six[python_targets_python2_7]
"

S=${WORKDIR}

src_install() {
	export DATA_DIR="${ED}/usr/share/ansible"
	export BIN_DIR="${ED}/usr/bin"
	sh build.sh install
	dodoc README.md
	dodoc -r ansible/examples docs/.
}
