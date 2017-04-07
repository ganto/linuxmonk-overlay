# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="WSGIProxy"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="HTTP proxying tools for WSGI apps"
HOMEPAGE="https://pypi.python.org/pypi/WSGIProxy"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/paste[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"
