# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Library that helps you to diff and patch dictionaries"
HOMEPAGE="https://github.com/inveniosoftware/dictdiffer"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( >=dev-python/sphinx-1.4.4
		>=dev-python/sphinx_rtd_theme-0.1.9 )
"

PATCHES=( "${FILESDIR}/${PN}-0.6.1-Remove-setup_requires.patch" )

DOCS=( AUTHORS CHANGES CONTRIBUTING.rst MAINTAINERS README.rst RELEASE-NOTES.rst )

python_compile_all() {
	default
	use doc && sphinx-build -N docs docs/_build/html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
