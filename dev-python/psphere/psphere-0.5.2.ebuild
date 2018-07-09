# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="vSphere SDK for Python"
HOMEPAGE="https://github.com/jkinred/psphere"
SRC_URI="https://github.com/jkinred/psphere/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/suds[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

DOCS=( CHANGES README.rst )

python_compile_all() {
	if use doc; then
		sphinx-build doc doc/_build/html
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
