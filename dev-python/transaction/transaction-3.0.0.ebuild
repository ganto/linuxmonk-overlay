# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 )
inherit distutils-r1

DESCRIPTION="Transaction management for Python"
HOMEPAGE="https://github.com/zopefoundation/transaction"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/zope-interface[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/repoze-sphinx-autointerface[${PYTHON_USEDEP}]
	)
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

DOCS=( CHANGES.rst README.rst )

python_compile_all() {
	use doc && esetup.py build_sphinx -b html
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	distutils-r1_python_install_all
}
