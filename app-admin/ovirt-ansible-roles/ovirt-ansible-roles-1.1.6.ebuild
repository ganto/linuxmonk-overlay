# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CLUSTER_UPGRADE_VERSION=1.1.11
DESASTER_RECOVERY_VERSION=1.1.4
ENGINE_SETUP_VERSION=1.1.7
HOSTED_ENGINE_SETUP_VERSION=1.0.8
IMAGE_TEMPLATE_VERSION=1.1.9
INFRA_VERSION=1.1.11
MANAGEIQ_VERSION=1.1.13
REPOSITORIES_VERSION=1.1.4
SHUTDOWN_ENV_VERSION=1.0.3
VM_INFRA_VERSION=1.1.12
V2V_CONVERSION_HOST_VERSION=1.9.1

DESCRIPTION="oVirt related Ansible roles"
HOMEPAGE="https://github.com/oVirt/ovirt-ansible"
SRC_URI="https://github.com/oVirt/ovirt-ansible/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	>=app-admin/ansible-2.7.2
	>=app-admin/ovirt-ansible-cluster-upgrade-1.1.9
	>=app-admin/ovirt-ansible-disaster-recovery-0.1
	>=app-admin/ovirt-ansible-engine-setup-1.1.6
	>=app-admin/ovirt-ansible-image-template-1.1.9
	>=app-admin/ovirt-ansible-infra-1.1.10
	>=app-admin/ovirt-ansible-manageiq-1.1.13
	>=app-admin/ovirt-ansible-repositories-1.1.3
	>=app-admin/ovirt-ansible-vm-infra-1.1.12
	>=app-admin/ovirt-ansible-v2v-conversion-host-1.0.0
	>=app-admin/ovirt-ansible-hosted-engine-setup-1.0.0
	>=app-admin/ovirt-ansible-shutdown-env-1.0.0
"

S="${WORKDIR}"

src_install() {
	dodoc README.md
	dodoc -r examples
}
