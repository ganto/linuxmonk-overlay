# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_3 )

MY_PN="PyBrowserID"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

inherit distutils-r1

DESCRIPTION="Client library for the BrowserID protocol"
HOMEPAGE="https://pypi.python.org/pypi/PyBrowserID https://github.com/rtilder/PyBrowserID"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}]
			dev-python/unittest2[${PYTHON_USEDEP}] )"

python_test() {
	nosetests -s browserid
}
