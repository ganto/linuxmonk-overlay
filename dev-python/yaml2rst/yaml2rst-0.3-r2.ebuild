# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="A Simple Tool for Documenting YAML Files"
HOMEPAGE="
	https://github.com/htgoebel/yaml2rst
	https://pypi.python.org/pypi/yaml2rst
"
SRC_URI="https://github.com/debops/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

distutils_enable_tests pytest

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
