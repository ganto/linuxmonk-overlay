# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

KUBERNETES_BASE_COMMIT=2da2b981ca806b25487ad92d01a2164815c18517

DESCRIPTION="Kubernetes python client"
HOMEPAGE="https://pypi.python.org/pypi/kubernetes https://github.com/kubernetes-client/python"
SRC_URI="https://github.com/kubernetes-client/python/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/kubernetes-client/python-base/archive/${KUBERNETES_BASE_COMMIT}/python-base-${KUBERNETES_BASE_COMMIT:0:7}.tar.gz -> kubernetes-python-base-${KUBERNETES_BASE_COMMIT:0:7}.tar.gz"

LICENSE="Apache-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/google-auth-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.5.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.24.2[${PYTHON_USEDEP}]
	>=dev-python/websocket-client-0.32.0[${PYTHON_USEDEP}]
	!~dev-python/websocket-client-0.40.0[${PYTHON_USEDEP}]
	!=dev-python/websocket-client-0.41*[${PYTHON_USEDEP}]
	!=dev-python/websocket-client-0.42*[${PYTHON_USEDEP}]
"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

S="${WORKDIR}/${P##kubernetes-client-}"

src_unpack() {
	unpack ${P}.tar.gz || die
	cd "${S}"
	tar -x -C kubernetes/base --strip-components=1 -f "${DISTDIR}"/kubernetes-python-base-${KUBERNETES_BASE_COMMIT:0:7}.tar.gz || die
}
