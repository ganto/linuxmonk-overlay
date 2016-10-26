# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )
inherit distutils-r1

MY_SHA=4a922f41490af54c4293da0ce92054c5354cf46b

DESCRIPTION="Linting/reformatting tool for YAML files documented with inline RST"
HOMEPAGE="https://github.com/ypid/yaml4rst"
SRC_URI="https://github.com/ypid/${PN}/archive/${MY_SHA}.zip -> ${P}.zip"

LICENSE="AFL-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${MY_SHA}"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# don't install tests
	sed -i 's/find_packages()/find_packages(exclude=("tests",))/' setup.py
}
