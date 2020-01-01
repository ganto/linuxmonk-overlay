# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} )
inherit distutils-r1

DESCRIPTION="Linting/reformatting tool for YAML files documented with inline RST"
HOMEPAGE="https://github.com/ypid/yaml4rst"
SRC_URI="https://github.com/ypid/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AFL-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
