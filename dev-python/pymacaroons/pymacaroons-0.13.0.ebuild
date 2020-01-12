# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Macaroon library for Python"
HOMEPAGE="https://github.com/ecordell/pymacaroons https://pypi.org/project/pymacaroons/"
SRC_URI="https://github.com/ecordell/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/pynacl-1.1.2[${PYTHON_USEDEP}]
	<dev-python/pynacl-2[${PYTHON_USEDEP}]
	>=dev-python/six-1.8.0[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		<dev-python/mock-2.99[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests nose

#python_test() {
#	nosetests --verbose tests/functional_tests || die "Tests fail with ${EPYTHON}"
#}
