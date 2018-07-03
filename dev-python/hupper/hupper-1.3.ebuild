# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="Integrated process monitor for developing and reloading daemons"
HOMEPAGE="https://github.com/Pylons/hupper"
SRC_URI="https://github.com/Pylons/hupper/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/pylons-sphinx-themes[${PYTHON_USEDEP}]
	)
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES.rst CONTRIBUTING.rst CONTRIBUTORS.txt README.rst )

python_compile_all() {
	if use doc; then
		PYTHONPATH=$(pwd)/src emake -C docs html SPHINXOPTS="-W -E"
	fi
}

python_test() {
	# if test fail with "watchdog error: inotify watch limit reached"
	# make sure to set `sysctl fs.inotify.max_user_watches` high enough
	py.test
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
