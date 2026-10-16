# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Kubernetes python client"
HOMEPAGE="
	https://github.com/kubernetes-client/python
	https://pypi.python.org/pypi/kubernetes
"
SRC_URI="https://github.com/kubernetes-client/python/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${P##kubernetes-client-}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/aiohttp-3.14.3[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-retry-2.9.1[${PYTHON_USEDEP}]
	>=dev-python/certifi-2026.7.22[${PYTHON_USEDEP}]
	>=dev-python/durationpy-0.11[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.13.5[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-6.0.3[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.16.0[${PYTHON_USEDEP}]
	<dev-python/urllib3-3[${PYTHON_USEDEP}]
	>=dev-python/urllib3-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
"
BDEPEND="
	>=dev-python/setuptools-84.0.0[${PYTHON_USEDEP}]
"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

EPYTEST_PLUGINS=()
EPYTEST_IGNORE=(
	# Require a live Kubernetes cluster, excluded by upstream's tox.ini.
	kubernetes/e2e_test
	kubernetes/aio/e2e_test
)
distutils_enable_tests pytest

src_prepare() {
	# Match the published release, including the asynchronous client.
	cp setup-release.py setup.py || die
	distutils-r1_src_prepare
}
