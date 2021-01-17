# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit distutils-r1 git-r3

DESCRIPTION="Linting/reformatting tool for YAML files documented with inline RST"
HOMEPAGE="https://github.com/ypid/yaml4rst"
EGIT_REPO_URI="git://github.com/ypid/yaml4rst.git"
EGIT_BRANCH="master"

LICENSE="AFL-3.0"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
