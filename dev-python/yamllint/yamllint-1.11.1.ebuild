# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )
inherit distutils-r1

DESCRIPTION="A linter for YAML files"
HOMEPAGE="https://github.com/adrienverge/yamllint"
SRC_URI="https://github.com/adrienverge/yamllint/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DOCS=( CHANGELOG.rst README.rst )

RDEPEND="
	>=dev-python/pathspec-0.5.3[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	esetup.py test || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}
