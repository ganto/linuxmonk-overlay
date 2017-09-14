# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

GIT_COMMIT=3a1484ae27735213fc01a27457b31c02c130034b
MY_PN="WPSeku"
MY_P="${MY_PN}-${GIT_COMMIT}"

DESCRIPTION="Black box WordPress vulnerability scanner"
HOMEPAGE="https://github.com/m4ll0k/WPSeku"
SRC_URI="https://github.com/m4ll0k/${MY_PN}/archive/${GIT_COMMIT}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${MY_PN}-0.2.1-Make-data-import-more-robust.patch"
	"${FILESDIR}/${MY_PN}-0.2.1-Add-setup.py-packaging.patch"
)

S="${WORKDIR}/${MY_P}"
