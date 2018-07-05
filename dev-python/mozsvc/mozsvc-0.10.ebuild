# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

MY_PN="mozservices"
MY_P=${MY_PN}-${PV}
MY_SHA="706e09b78a78ebff4f71dcaca2fd7b68fa2885fb"

DESCRIPTION="Various utilities for Mozilla apps"
HOMEPAGE="https://github.com/mozilla-services/mozservices"
SRC_URI="https://github.com/mozilla-services/${MY_PN}/archive/${MY_SHA}.zip -> ${MY_P}.zip"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-python/konfig[${PYTHON_USEDEP}]
	>=dev-python/pyramid-1.5[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/cornice-0.10[${PYTHON_USEDEP}]
		dev-python/gevent[${PYTHON_USEDEP}]
		>=dev-python/hawkauthlib-0.1.1[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyramid_hawkauth[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
		dev-python/tokenlib[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
		dev-python/wsgiproxy[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
	)
"

DOCS=( README.txt CHANGES.txt )

S="${WORKDIR}/${MY_PN}-${MY_SHA}"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# Fix IP address in test suite
	sed -i 's/195\.154\.97\.69/163.172.47.3/' mozsvc/tests/test_util.py
}

python_test() {
	nosetests -v mozsvc.tests || die "Test failed with ${EPYTHON}"
}
