# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

MY_PN="${PN%%-python}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python SDK for oVirt Engine API"
HOMEPAGE="
	https://www.ovirt.org/
	https://github.com/oVirt/ovirt-engine-sdk
"
SRC_URI="https://resources.ovirt.org/pub/ovirt-4.4/src/python-ovirt-engine-sdk4/${P}.tar.gz"
# needs local ovirt instance to run tests
RESTRICT="
	mirror
	test
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="
	dev-libs/libxml2
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

DOCS=( README.adoc )

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto /usr/share/doc/${PF}/examples
		dodoc examples/*
	fi
}
