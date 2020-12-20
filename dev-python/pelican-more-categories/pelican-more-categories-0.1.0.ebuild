# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="Pelican plugin to add support for multiple categories per article"
HOMEPAGE="https://pypi.org/project/pelican-more-categories/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=app-text/pelican-4.2.0[${PYTHON_USEDEP}]"
