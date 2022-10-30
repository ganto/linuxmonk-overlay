# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Kubernetes python client"
HOMEPAGE="https://pypi.python.org/pypi/kubernetes https://github.com/kubernetes-client/python"
SRC_URI="https://github.com/kubernetes-client/python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.4.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.24.2[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

S="${WORKDIR}/${P##kubernetes-client-}"

distutils_enable_tests pytest
