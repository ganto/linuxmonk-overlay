# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1

DESCRIPTION="Library that helps you to diff and patch dictionaries"
HOMEPAGE="https://github.com/inveniosoftware/dictdiffer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( >=dev-python/sphinx-1.4.4
		>=dev-python/sphinx_rtd_theme-0.1.9 )
"

PATCHES=( "${FILESDIR}"/0.8.0-Remove-setup_requires.patch )

DOCS=( AUTHORS CHANGES CONTRIBUTING.rst MAINTAINERS README.rst )

python_compile_all() {
	default
	use doc && sphinx-build -N docs docs/_build/html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
