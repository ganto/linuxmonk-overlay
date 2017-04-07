# Copyright 1999-2016 Gentoo Foundation
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
	test? (	<dev-python/cornice-1.0
		dev-python/gevent
		dev-python/hawkauthlib
		dev-python/pyramid_hawkauth
		dev-python/testfixtures
		dev-python/tokenlib
		dev-python/unittest2
		dev-python/webtest
		dev-python/wsgiproxy
		www-servers/gunicorn
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
