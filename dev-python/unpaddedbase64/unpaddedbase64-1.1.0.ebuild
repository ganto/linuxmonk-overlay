# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Encode and decode Base64 without '=' padding"
HOMEPAGE="https://github.com/matrix-org/python-unpaddedbase64 https://pypi.org/project/unpaddedbase64/"
SRC_URI="https://github.com/matrix-org/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

S="${WORKDIR}/python-${P}"
