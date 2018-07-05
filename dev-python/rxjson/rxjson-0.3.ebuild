# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="JSON RX Schema validation tool"
HOMEPAGE="http://rx.codesimply.com/ https://github.com/spiral-project/rxjson"
SRC_URI="https://github.com/spiral-project/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytap[${PYTHON_USEDEP}] )
"

python_test() {
	cd tests
	${PYTHON} rx-test.py || die "Test failed with ${EPYTHON}"
}
