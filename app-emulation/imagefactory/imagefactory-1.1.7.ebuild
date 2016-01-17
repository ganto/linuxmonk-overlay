# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="System image generation tool"
HOMEPAGE="http://imgfac.org"
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/${PN}/${P}.tar.gz/1c7d7e3a0f22eae3eaa64e2b98bd851f/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="aws test"

RDEPEND="${PYTHON_DEPS}
	app-emulation/libguestfs[python,${PYTHON_USEDEP}]
	app-emulation/oz[${PYTHON_USEDEP}]
	dev-libs/libxml2:2[python,${PYTHON_USEDEP}]
	aws? ( dev-python/boto[${PYTHON_USEDEP}] )
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/boto[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

python_test() {
	nosetests --verbose || die
}
