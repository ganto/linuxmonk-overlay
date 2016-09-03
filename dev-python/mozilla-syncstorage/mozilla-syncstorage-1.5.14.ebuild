# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="server-syncstorage"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Storage Engine for Firefox Sync Server"
HOMEPAGE="https://github.com/mozilla-services/server-syncstorage"
SRC_URI="https://github.com/mozilla-services/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="mysql test"

RDEPEND="
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/configparser[${PYTHON_USEDEP}]
	<dev-python/cornice-1.0[${PYTHON_USEDEP}]
	dev-python/gevent[${PYTHON_USEDEP}]
	dev-python/hawkauthlib[${PYTHON_USEDEP}]
	dev-python/konfig[${PYTHON_USEDEP}]
	dev-python/mozsvc[${PYTHON_USEDEP}]
	>=dev-python/paste-2.0.2[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	mysql? ( dev-python/pymysql[${PYTHON_USEDEP}] )
	dev-python/pyramid[${PYTHON_USEDEP}]
	dev-python/repoze-lru[${PYTHON_USEDEP}]
	>=dev-python/requests-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-1.0.8[${PYTHON_USEDEP}]
	dev-python/tokenlib[${PYTHON_USEDEP}]
	dev-python/traceback2[${PYTHON_USEDEP}]
	dev-python/translationstring[${PYTHON_USEDEP}]
	dev-python/umemcache[${PYTHON_USEDEP}]
	dev-python/wsgiproxy[${PYTHON_USEDEP}]
	>=dev-python/webob-1.4.1[${PYTHON_USEDEP}]
	!~dev-python/webob-1.5[${PYTHON_USEDEP}]
	dev-python/zope-deprecation[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pybrowserid[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
		www-servers/gunicorn[${PYTHON_USEDEP}]
	)
"

DOCS=( CONTRIBUTORS.txt README )

python_test() {
	nosetests -s syncstorage.tests || die "Offline tests fail with ${EPYTHON}"

	# Test that live functional tests can run correctly, by actually
	# spinning up a server and running them against it.
	einfo "Starting gunicorn server to perform live tests"
	export MOZSVC_SQLURI=sqlite:///:memory:
	gunicorn --paste "${FILESDIR}"/syncstorage-tests.ini --debug --error-logfile "${T}"/gunicorn_test.log --workers 1 --worker-class mozsvc.gunicorn_worker.MozSvcGeventWorker & server_pid=$!
	sleep 2
	${PYTHON} syncstorage/tests/functional/test_storage.py http://localhost:5000; return=$?
	kill $server_pid
	test $return -eq 0 || die "Live tests fail with ${EPYTHON}"
}
