# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_PV=${PV%%_p*}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Library and utilities for automated guest OS installs"
HOMEPAGE="https://github.com/clalancette/oz"
SRC_URI="https://github.com/clalancette/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/libvirt-python[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/m2crypto[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	')
"
RDEPEND="${DEPEND}
	app-cdr/cdrtools
	>=app-emulation/libguestfs-1.18[${PYTHON_SINGLE_USEDEP}]
	app-emulation/libvirt[qemu]
	net-misc/openssh
	sys-fs/mtools
"

PATCHES=(
	"${FILESDIR}"/0.17.0-Python3-monotonic.patch
	"${FILESDIR}"/0.17.0-Fix-API-calls-for-new-useuefi-parameter.patch
	"${FILESDIR}"/0.17.0-Fix-test-suite.patch
	"${FILESDIR}"/0.18.0-GH292-ozutils-collections-to-collections-abc.patch
	"${FILESDIR}"/0.18.0-Replace-genisoimage-with-mkisofs.patch
	"${FILESDIR}"/0.18.1-GH296-Enable-USB-controller-and-keyboard-for-aarch64.patch
	"${FILESDIR}"/0.18.1-GH297-Revert-Don-t-write-kickstart.patch
)

S="${WORKDIR}/${MY_P}"

distutils_enable_tests pytest

python_test() {
	PYTHONPATH="${BUILD_DIR}"/lib py.test || die "Tests fail for ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/oz
	doins oz.cfg
}
