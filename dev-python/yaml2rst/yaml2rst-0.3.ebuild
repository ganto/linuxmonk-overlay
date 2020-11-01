# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A Simple Tool for Documenting YAML Files"
HOMEPAGE="https://pypi.python.org/pypi/yaml2rst https://github.com/htgoebel/yaml2rst"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
