# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1 eutils systemd

MY_PN=synapse
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Reference homeserver for the Matrix decentralised comms protocol"
HOMEPAGE="https://matrix.org/docs/projects/server/synapse.html"
SRC_URI="https://github.com/matrix-org/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test systemd"

DEPEND="
	>=dev-python/attrs-17.4.0[${PYTHON_USEDEP}]
	>=dev-python/bcrypt-3.1.0[${PYTHON_USEDEP}]
	>=dev-python/bleach-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/canonicaljson-1.1.3[${PYTHON_USEDEP}]
	>=dev-python/daemonize-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/frozendict-1.0[${PYTHON_USEDEP}]
	>=dev-python/idna-2.5[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.9[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.5.2[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/phonenumbers-8.2.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-4.3.0[jpeg,${PYTHON_USEDEP}]
	>=dev-python/prometheus_client-0.0.18[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.9[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-0.0.7[${PYTHON_USEDEP}]
	>=dev-python/pymacaroons-0.13.0[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.2.1[${PYTHON_USEDEP}]
	>=dev-python/pyopenssl-16.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
	>=dev-python/service_identity-18.1.0[${PYTHON_USEDEP}]
	>=dev-python/signedjson-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	>=dev-python/sortedcontainers-1.4.4[${PYTHON_USEDEP}]
	>=dev-python/treq-15.1[${PYTHON_USEDEP}]
	>=dev-python/twisted-18.9.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.7.4[${PYTHON_USEDEP}]
	>=dev-python/unpaddedbase64-1.1.0[${PYTHON_USEDEP}]

	systemd? ( >=dev-python/python-systemd-231[${PYTHON_USEDEP}] )
"
RDEPEND="
	${DEPEND}
	acct-user/matrix-synapse
	acct-group/matrix-synapse
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

DOCS=( AUTHORS.rst CHANGES.md CONTRIBUTING.md INSTALL.md README.rst UPGRADE.rst )

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils-r1_src_install

	doman "${FILESDIR}/man-pages/hash_password.1"
	doman "${FILESDIR}/man-pages/register_new_matrix_user.1"
	doman "${FILESDIR}/man-pages/synapse_port_db.1"
	doman "${FILESDIR}/man-pages/synctl.1"

	dodir /etc/matrix-synapse
	insinto /etc/matrix-synapse/
	doins "${FILESDIR}/homeserver.yaml" "${FILESDIR}/log.yaml"

	fowners matrix-synapse:nogroup /etc/matrix-synapse

	keepdir /etc/matrix-synapse/conf.d

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/matrix-synapse.logrotate" matrix-synapse

	diropts -m750

	keepdir /var/lib/matrix-synapse/uploads
	keepdir /var/log/matrix-synapse

	systemd_dounit "${FILESDIR}/matrix-synapse.service"

	fowners matrix-synapse:matrix-synapse /var/lib/matrix-synapse/uploads/
	fowners matrix-synapse:matrix-synapse /var/log/matrix-synapse/

	fperms 0750 /var/lib/matrix-synapse/uploads/ /var/log/matrix-synapse/
}

pkg_postinst() {
	einfo "By default Synapse will use a SQLite database backend which is fine for testing."
	einfo "For a production setup please install:"
	optfeature "PostgreSQL backend support" dev-python/psycopg:2
	einfo ""
	einfo "Before you can start the service, the public hostname of the Synapse"
	einfo "service needs to be defined (for more information on how to choose your"
	einfo "server name see: https://github.com/matrix-org/synapse/blob/master/INSTALL.md):"
	einfo ""
	einfo "    echo 'server_name: example.com' > /etc/matrix-synapse/conf.d/server_name.yaml"
	einfo ""
	einfo "Define if you want to report anonymized homeserver usage statistics:"
	einfo ""
	einfo "    echo 'report_stats: false' > /etc/matrix-synapse/conf.d/report_stats.yaml"
	einfo ""
}
