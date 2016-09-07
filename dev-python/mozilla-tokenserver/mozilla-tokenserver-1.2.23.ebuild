# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils

MY_PN="tokenserver"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="The Mozilla Token Server"
HOMEPAGE="https://github.com/mozilla-services/tokenserver"
SRC_URI="https://github.com/mozilla-services/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RDEPEND="
	dev-python/alembic[${PYTHON_USEDEP}]
	dev-python/boto[${PYTHON_USEDEP}]
	dev-python/pybrowserid[${PYTHON_USEDEP}]
	<dev-python/cornice-1.0[${PYTHON_USEDEP}]
	dev-python/gevent[${PYTHON_USEDEP}]
	dev-python/hawkauthlib[${PYTHON_USEDEP}]
	dev-python/mozsvc[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/pyramid[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/tokenlib[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
	dev-python/zope-deprecation[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	test? (	dev-python/nose[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)
"

DOCS=( README.md )

python_test() {
	nosetests tokenserver/tests || die "Test fail with ${EPYTHON}"
}

python_compile_all() {
	if use doc; then
		"${PYTHON}" setup.py build_sphinx -b html
	fi
	"${PYTHON}" setup.py build_sphinx -b man
}

python_install_all() {
	use doc && local HTML_DOCS=( build/sphinx/html/. )
	distutils-r1_python_install_all

	doman build/sphinx/man/tokenserver.1

	docinto example_config
	dodoc -r *.ini etc/*
}

pkg_postinst() {
	elog "Optional features"
	optfeature "Standalone mode" dev-python/pastescript
	optfeature "MySQL backend" dev-python/pymysql
	echo ""
	elog "Example configuration files are available in the documentation directory."
}
