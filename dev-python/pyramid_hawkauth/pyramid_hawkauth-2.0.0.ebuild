# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

# source archive tagged v0.2.0 instead of v2.0.0
MY_PV=0.2.0

DESCRIPTION="Hawk Access Auth plugin for pyramid"
HOMEPAGE="https://github.com/mozilla-services/pyramid_hawkauth"
SRC_URI="https://github.com/mozilla-services/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND=">=dev-python/pyramid-1.6[${PYTHON_USEDEP}]
	>=dev-python/hawkauthlib-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/tokenlib-2.0.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/${PN}-${MY_PV}"

python_test() {
	pytest -v pyramid_hawkauth/tests || die "Tests failed for ${EPYTHON}"
}
