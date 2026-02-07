# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1

DESCRIPTION="A recursive external node classifier for automation tools"
HOMEPAGE="https://github.com/salt-formulas/reclass"
SRC_URI="https://github.com/salt-formulas/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror"

DEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? ( dev-python/ddt[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/1.7.0-tests-Replace-deprecated-assertEquals.patch
	"${FILESDIR}"/1.7.1-Replace-distutils.version-with-packaging.version.patch
)

EPYTEST_PLUGINS=()
distutils_enable_sphinx doc/source
distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all
	dodoc -r examples
}

python_test() {
	emake tests || die "Tests failed with ${EPYTHON}"
}
