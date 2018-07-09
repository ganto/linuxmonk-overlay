# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Library and utilities for automated guest OS installs"
HOMEPAGE="https://github.com/clalancette/oz"
SRC_URI="https://github.com/clalancette/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

COMMON_DEPEND="
	dev-python/libvirt-python[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/m2crypto[${PYTHON_USEDEP}]
	dev-python/monotonic[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	app-cdr/cdrtools
	app-emulation/libvirt[qemu]
	net-misc/openssh
	sys-fs/mtools
"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${P}-Replace-genisoimage-with-mkisofs.patch
	"${FILESDIR}"/${P}-Read-home-directory-from-environment.patch
)

python_test() {
	PYTHONPATH="${BUILD_DIR}"/lib py.test || die "Tests fail for ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/oz
	doins oz.cfg
}
