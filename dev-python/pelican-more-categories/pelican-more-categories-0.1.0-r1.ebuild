# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..14} )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Pelican plugin to add support for multiple categories per article"
HOMEPAGE="
	https://github.com/pelican-plugins/more-categories/
	https://pypi.org/project/pelican-more-categories/
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-text/pelican-4.2.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=(
	# https://github.com/pelican-plugins/more-categories/pull/9
	"${FILESDIR}/${P}-Require-Python-3.8+.patch"
)
