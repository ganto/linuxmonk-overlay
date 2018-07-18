# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="oVirt related Ansible roles"
HOMEPAGE="https://github.com/oVirt/ovirt-ansible"
SRC_URI="https://github.com/oVirt/ovirt-ansible/releases/download/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	>=app-admin/ansible-2.3.0
	dev-python/jmespath
	dev-python/ovirt-engine-sdk-python
"

S="${WORKDIR}"

src_prepare() {
	default
	sed -i 's|^PREFIX=.*$|PREFIX=/usr|' Makefile
}
