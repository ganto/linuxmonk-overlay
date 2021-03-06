# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

MY_PN="${PN%%-restclient-python}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python client for the OpenShift API"
HOMEPAGE="https://github.com/openshift/openshift-restclient-python"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	=dev-python/kubernetes-client-python-11*[${PYTHON_USEDEP}]
	dev-python/python-string-utils[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${MY_PN}-0.6.1-Fix-install_requires.patch" )

S="${WORKDIR}/${MY_P}"

python_install() {
	distutils-r1_python_install
	# cleanup inproper packaging (see python-openshift.spec)
	rm -r "${ED}"$(python_get_sitedir)/scripts
	rm -r "${ED}"/usr/requirements.txt
	rm -r "${ED}"/usr/custom_objects_spec.json
}
