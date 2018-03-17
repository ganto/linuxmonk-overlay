# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1 bash-completion-r1

DESCRIPTION="Command line tool to invoke vcs commands on multiple repositories"
HOMEPAGE="https://github.com/dirk-thomas/vcstool"
SRC_URI="https://github.com/dirk-thomas/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.rst CONTRIBUTING.md README.rst )

PATCHES=( "${FILESDIR}"/vcstool-0.1.34-Setuptools-no-completions.patch )

python_test() {
	pytest -s -v test/test_commands.py test/test_options.py || die "Test failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	pushd vcstool-completion || die
	newbashcomp vcs.bash vcs
	insinto /usr/share/zsh/site-functions
	newins vcs.zsh _vcs
	popd || die # vcstool-completion
}
