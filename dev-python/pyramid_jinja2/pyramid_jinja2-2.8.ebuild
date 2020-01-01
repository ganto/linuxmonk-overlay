# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Jinja2 templating system bindings for the Pyramid web framework"
HOMEPAGE="https://github.com/Pylons/pyramid_jinja https://pypi.python.org/pypi/pyramid_jinja2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/jinja-2.5[${PYTHON_USEDEP}]
	dev-python/markupsafe[${PYTHON_USEDEP}]
	>=dev-python/pyramid-1.3.0[${PYTHON_USEDEP}]
	dev-python/zope-deprecation[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/pylons-sphinx-themes-0.3[${PYTHON_USEDEP}]
	)
	test? ( ${RDEPEND}
		>=dev-python/nose-1.2.0[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES.txt CONTRIBUTORS.txt rtd.txt )

python_test() {
	nosetests -s pyramid_jinja2.tests || die "Test failed for ${EPYTHON}"
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_install_all() {
	use doc && local HTML_DOCS=( sphinx/html/. )
	distutils-r1_python_install_all
}