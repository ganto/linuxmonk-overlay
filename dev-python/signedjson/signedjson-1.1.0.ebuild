# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Sign JSON with Ed25519 signatures"
HOMEPAGE="https://github.com/matrix-org/python-signedjson https://pypi.org/project/signedjson/"
SRC_URI="https://github.com/matrix-org/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/canonicaljson-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pynacl-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.5[${PYTHON_USEDEP}]
	>=dev-python/unpaddedbase64-1.0.1[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}"

distutils_enable_tests nose

S="${WORKDIR}/python-${P}"
