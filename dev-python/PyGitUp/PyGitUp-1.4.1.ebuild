# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A Python implementation of git up"
HOMEPAGE="https://github.com/msiemens/PyGitUp"
SRC_URI="https://github.com/msiemens/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="blackshades"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	>=dev-python/colorama-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/docopt-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/git-python-1.0.2[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/termcolor-1.1.0[${PYTHON_USEDEP}]
	dev-vcs/git
"

DOCS=( README.rst )

python_test() {
	# exclude tests trying to connect to the internet
	export NOSE_EXCLUDE="test_(bundler|version)"

	nosetests -v || die "Tests failed for ${EPYTHON}"
}
