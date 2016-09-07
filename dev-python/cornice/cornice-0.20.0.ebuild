# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4} )
inherit distutils-r1

DESCRIPTION="Restful services for Pyramid"
HOMEPAGE="https://github.com/mozilla-services/cornice"
SRC_URI="https://github.com/mozilla-services/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples test"

RDEPEND="
	dev-python/pyramid[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/pastescript[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/mozilla-sphinx-theme[${PYTHON_USEDEP}]
		)
	test? ( dev-python/colander[${PYTHON_USEDEP}]
		dev-python/iso8601[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/rxjson[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
		)
"

DOCS=( CHANGES.txt CONTRIBUTORS.txt README.rst )

python_compile_all() {
	if use doc; then
		${PYTHON} setup.py build_sphinx
	fi
}

python_test() {
	nosetests
}

python_install_all() {
	use doc && local HTML_DOCS=( build/sphinx/html/. )
	distutils-r1_python_install_all

	if use examples; then
		docinto examples
		dodoc -r examples/*
	fi
}
