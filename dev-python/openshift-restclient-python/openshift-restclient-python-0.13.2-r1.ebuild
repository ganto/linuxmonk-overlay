# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
PYPI_PN="${PN%%-restclient-python}"

inherit distutils-r1 pypi

DESCRIPTION="Python client for the OpenShift API"
HOMEPAGE="https://github.com/openshift/openshift-restclient-python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/kubernetes-client-python[${PYTHON_USEDEP}]
	dev-python/python-string-utils[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
"

python_install() {
	distutils-r1_python_install

	# don't install scripts to site-packages
	rm -rvf "${ED}"/usr/lib*/py*/site-packages/scripts
}
