# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Library and utilities for automated guest OS installs"
HOMEPAGE="https://github.com/clalancette/oz"
SRC_URI="https://github.com/clalancette/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="
	app-emulation/libguestfs[python,${PYTHON_USEDEP}]
	>=dev-python/libvirt-python-0.9.7[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/m2crypto[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]"

RDEPEND="${CDEPEND}
	app-cdr/cdrkit
	app-emulation/libvirt[qemu]
	net-misc/openssh
	sys-fs/mtools"

DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test || die
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/oz
	doins oz.cfg
}
