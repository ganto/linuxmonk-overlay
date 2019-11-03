# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=azure-activedirectory-library-for-python
MY_P=${MY_PN}-${PV}

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1

DESCRIPTION="Azure Active Directory Authentication Library (ADAL) for Python"
HOMEPAGE="https://github.com/AzureAD/azure-activedirectory-library-for-python"
SRC_URI="https://github.com/AzureAD/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
# requires network access
RESTRICT="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/httpretty[${PYTHON_USEDEP}] )
"
RDEPEND="
	>=dev-python/cryptography-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	>=dev-python/pyjwt-1.7.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
"
BDEPEND=""

S="${WORKDIR}"/${MY_P}

python_test() {
	${EPYTHON} -m unittest discover -s tests || die "Tests failed for ${EPYTHON}"
}
