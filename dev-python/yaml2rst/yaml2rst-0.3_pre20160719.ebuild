# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

COMMIT_ID=1a757a4ae2af94ba680cbc62b2bc9744bf5fc4f4

DESCRIPTION="A Simple Tool for Documenting YAML Files"
HOMEPAGE="https://pypi.python.org/pypi/yaml2rst https://github.com/htgoebel/yaml2rst"
SRC_URI="https://github.com/htgoebel/${PN}/archive/${COMMIT_ID}.zip -> ${P}.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${COMMIT_ID}"

python_test() {
	esetup.py test
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
