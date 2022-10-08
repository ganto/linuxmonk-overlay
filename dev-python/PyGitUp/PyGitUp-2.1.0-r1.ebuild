# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A Python implementation of git up"
HOMEPAGE="https://github.com/msiemens/PyGitUp"
SRC_URI="https://github.com/msiemens/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="blackshades"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/colorama-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/GitPython-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/termcolor-1.1.0[${PYTHON_USEDEP}]
"

DOCS=( README.rst )

PATCHES=(
	"${FILESDIR}"/2.1.0-refactor-Add-support-for-Python-3.10.patch
	"${FILESDIR}"/2.1.0-build-use-lighter-poetry-core.patch
)

distutils_enable_tests pytest
