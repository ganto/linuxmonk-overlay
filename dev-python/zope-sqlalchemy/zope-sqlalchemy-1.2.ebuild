# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

MY_PN=${PN/-/.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Minimal Zope/SQLAlchemy transaction integration"
HOMEPAGE="https://pypi.org/project/zope.sqlalchemy/ https://github.com/zopefoundation/zope.sqlalchemy"
SRC_URI="mirror://pypi/${MY_PN::1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/sqlalchemy-0.7[${PYTHON_USEDEP}]
	>=dev-python/transaction-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-3.6.0[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

distutils_enable_tests setup.py

python_install_all() {
	distutils-r1_python_install_all

	# remove .pth files since dev-python/namespace-zope handles the ns
	find "${D}" -name '*.pth' -delete || die
}
