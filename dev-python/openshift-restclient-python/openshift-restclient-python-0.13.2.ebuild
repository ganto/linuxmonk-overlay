# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10,11} )
PYPI_PN="${PN%%-restclient-python}"

inherit distutils-r1 pypi

DESCRIPTION="Python client for the OpenShift API"
HOMEPAGE="https://github.com/openshift/openshift-restclient-python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-python/kubernetes-client-python-12.0[${PYTHON_USEDEP}]
	dev-python/python-string-utils[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
