# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="A loader implementing the PasteDeploy syntax to be used by plaster"
HOMEPAGE="https://github.com/Pylons/plaster_pastedeploy"
SRC_URI="https://github.com/Pylons/plaster_pastedeploy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/plaster[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES.rst CONTRIBUTING.rst CONTRIBUTORS.txt README.rst )

S="${WORKDIR}"/${PN/-/_}-${PV}

python_test() {
	PYTHONPATH=$(pwd)/src py.test || die "Test failed for ${EPYTHON}"
}
