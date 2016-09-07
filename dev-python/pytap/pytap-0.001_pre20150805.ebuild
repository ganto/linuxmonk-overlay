# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )
inherit distutils-r1

MY_PN="tapsimple"
MY_P="${MY_PN}-${PV}"
MY_SHA="69e32b92be0c4c303cd52ac454313f04789b0229"

DESCRIPTION="TAP emitter for Python"
HOMEPAGE="https://github.com/rjbs/tapsimple"
SRC_URI="https://github.com/rjbs/${MY_PN}/archive/${MY_SHA}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}-${MY_SHA}"
