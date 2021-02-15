# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Extends rich library functionality with a set of changes that were not accepted"
HOMEPAGE="https://github.com/pycontribs/enrich"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/rich-9.2.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-mock-3.3.1[${PYTHON_USEDEP}]
		dev-python/pytest-plus[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.29.0[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest
