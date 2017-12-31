# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

KUBERNETES_BASE_COMMIT=168c5e761fc8a60a332e38342fda04350d64fe33

DESCRIPTION="Kubernetes python client"
HOMEPAGE="https://pypi.python.org/pypi/kubernetes https://github.com/kubernetes-incubator/client-python"
SRC_URI="https://github.com/kubernetes-incubator/client-python/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/kubernetes-client/python-base/archive/${KUBERNETES_BASE_COMMIT}/python-base-${KUBERNETES_BASE_COMMIT:0:7}.tar.gz -> kubernetes-python-base-${KUBERNETES_BASE_COMMIT:0:7}.tar.gz"

LICENSE="Apache-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/ipaddress[${PYTHON_USEDEP}]' 'python2_7')
	>=dev-python/google-auth-1.0.1[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	!=dev-python/urllib3-1.21[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md RELEASE.md )

S="${WORKDIR}/${P##kubernetes-}"

src_unpack() {
	unpack ${P}.tar.gz || die
	cd "${S}"
	tar -x -C kubernetes/base --strip-components=1 -f "${DISTDIR}"/kubernetes-python-base-${KUBERNETES_BASE_COMMIT:0:7}.tar.gz || die
}
