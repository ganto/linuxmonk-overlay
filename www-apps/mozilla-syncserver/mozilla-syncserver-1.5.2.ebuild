# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils user

MY_PN="syncserver"
MY_P="${MY_PN}-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Mozilla Sync Server"
HOMEPAGE="https://github.com/mozilla-services/syncserver"
SRC_URI="https://github.com/mozilla-services/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-python/configparser[${PYTHON_USEDEP}]
	dev-python/mozilla-syncstorage[${PYTHON_USEDEP}]
	dev-python/mozilla-tokenserver[${PYTHON_USEDEP}]
	>=dev-python/mozsvc-0.8_p20141211[${PYTHON_USEDEP}]
	dev-python/pyramid[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/simplejson[${PYTHON_USEDEP}]
	dev-python/sqlalchemy[${PYTHON_USEDEP}]
	dev-python/zope-component[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
	    dev-python/unittest2[${PYTHON_USEDEP}]
		)
"

PATCHES=( "${FILESDIR}/${MY_P}-Use-randomly-generated-fxa.metrics_uid_secret_key.patch" )

pkg_setup() {
	enewgroup syncserver
	enewuser syncserver -1 -1 /var/lib/syncserver syncserver
}

python_test() {
	nosetests -v -s syncstorage.tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	diropts -m 0770
	dodir /var/lib/syncserver

	insinto /var/lib/syncserver
	insopts -m 0600 -o syncserver -g syncserver
	newins syncserver.ini syncserver.ini.example
	insopts -m 0644 -o syncserver -g syncserver
	doins syncserver.wsgi

	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "To run the application, a WSGI server is required. E.g."
	optfeature "Apache+mod_wsgi" www-apache/mod_wsgi
	optfeature "Gunicorn" www-servers/gunicorn
	optfeature "uWSGI" www-servers/uwsgi
	echo ""
	elog "Alternative database backends:"
	optfeature "MySQL/MariaDB" dev-python/mysql-python
	optfeature "PostgreSQL" dev-python/pypgsql
	echo ""
	elog "An example syncserver.ini and the WSGI script syncserver.wsgi were"
	elog "installed to /var/lib/syncserver."
	echo ""
	elog "For further configuration instructions see:"
	elog "https://docs.services.mozilla.com/howtos/run-sync-1.5.html"
}
