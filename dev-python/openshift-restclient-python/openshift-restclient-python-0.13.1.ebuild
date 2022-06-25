# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
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

RDEPEND="
	>=dev-python/kubernetes-client-python-12.0[${PYTHON_USEDEP}]
	dev-python/python-string-utils[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"
