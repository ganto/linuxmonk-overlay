# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )

inherit distutils-r1

DESCRIPTION="Python SDK for oVirt Engine API"
HOMEPAGE="https://www.ovirt.org/ https://github.com/oVirt/ovirt-engine-sdk"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="
	dev-libs/libxml2
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}