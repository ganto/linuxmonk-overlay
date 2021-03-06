# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Python module to parse Erlang BEAM files"
HOMEPAGE="https://github.com/matwey/pybeam https://pypi.org/project/pybeam/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/construct-2.9[${PYTHON_USEDEP}]
	<dev-python/construct-2.11[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="${RDEPEND}
	test? (
		dev-python/wheel[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests setup.py
