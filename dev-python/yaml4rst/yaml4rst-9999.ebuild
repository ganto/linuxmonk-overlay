# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )
inherit distutils-r1 git-r3

DESCRIPTION="Linting/reformatting tool for YAML files documented with inline RST"
HOMEPAGE="https://github.com/ypid/yaml4rst"
EGIT_REPO_URI="git://github.com/ypid/yaml4rst.git"
EGIT_BRANCH="master"

LICENSE="AFL-3.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
