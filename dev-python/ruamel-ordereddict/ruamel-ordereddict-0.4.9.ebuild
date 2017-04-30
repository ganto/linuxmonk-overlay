# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A version of dict that keeps keys in insertion resp. sorted order"
HOMEPAGE="https://bitbucket.org/ruamel/ordereddict"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/${MY_P}"

DOCS=( README.rst )

# TODO: Test suite fail
# check https://bitbucket.org/ruamel/ordereddict/issues/7/ordereddictc-807-dictresize-assertion
python_test() {
	touch "${BUILD_DIR}/lib/ruamel/__init__.py"
	${PYTHON} test/testordereddict.py || die "Tests failed under ${EPYTHON}"
	py.test test/test_ordereddict.py test/test_dictviews.py || die "Tests failed under ${EPYTHON}"
}
