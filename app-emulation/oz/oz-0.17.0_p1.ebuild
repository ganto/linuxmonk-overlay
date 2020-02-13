# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

MY_PV=${PV%%_p*}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Library and utilities for automated guest OS installs"
HOMEPAGE="https://github.com/clalancette/oz"
SRC_URI="https://github.com/clalancette/${PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/libvirt-python[${PYTHON_MULTI_USEDEP}]
		dev-python/lxml[${PYTHON_MULTI_USEDEP}]
		dev-python/m2crypto[${PYTHON_MULTI_USEDEP}]
		dev-python/monotonic[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
	')
"
RDEPEND="${DEPEND}
	app-cdr/cdrtools
	>=app-emulation/libguestfs-1.18[${PYTHON_SINGLE_USEDEP}]
	app-emulation/libvirt[qemu]
	net-misc/openssh
	sys-fs/mtools
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_MULTI_USEDEP}]
	')
	test? (
		$(python_gen_cond_dep '
			dev-python/pytest[${PYTHON_MULTI_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}"/${MY_PV}-01-clarify-bz-instance.patch
	"${FILESDIR}"/${MY_PV}-02-drop-armv7-special-console-handling.patch
	"${FILESDIR}"/${MY_PV}-03-add-appropriate-arch-checks.patch
	"${FILESDIR}"/${MY_PV}-04-armv7-define-gicv2.patch
	"${FILESDIR}"/${MY_PV}-05-arm-fix-input-devices.patch
	"${FILESDIR}"/${MY_PV}-06-setup-graphical-all-except-s390x.patch
	"${FILESDIR}"/${MY_PV}-07-use-2gb-ram.patch
	"${FILESDIR}"/${MY_PV}-08-add-latest-location-ovmf.patch
	"${FILESDIR}"/${MY_PV}-09-add-tianocore-check.patch
	"${FILESDIR}"/${MY_PV}-10-check-edk2-firmware-armv7.patch
	"${FILESDIR}"/${MY_PV}-11-make-uefi-configurable.patch
	"${FILESDIR}"/${MY_PV}-12-fix-f29-config.patch
	"${FILESDIR}"/${MY_PV}-13-add-f30-support.patch
	"${FILESDIR}"/${MY_PV}-Fix-API-calls-for-new-useuefi-parameter.patch
	"${FILESDIR}"/${MY_PV}-Fix-test-suite.patch
	"${FILESDIR}"/${MY_PV}-Replace-genisoimage-with-mkisofs.patch
	"${FILESDIR}"/oz-0.16.0-Read-home-directory-from-environment.patch
)

S="${WORKDIR}/${MY_P}"

python_test() {
	PYTHONPATH="${BUILD_DIR}"/lib py.test || die "Tests fail for ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/oz
	doins oz.cfg
}
