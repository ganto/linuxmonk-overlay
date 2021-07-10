# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A recursive external node classifier for automation tools"
HOMEPAGE="https://github.com/salt-formulas/reclass"
SRC_URI="https://github.com/salt-formulas/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="!test? ( test ) mirror"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RDEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/ddt[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/1.7.0-setup-py-Avoid-enum34-dependency.patch
	"${FILESDIR}"/1.7.0-setup-py-Remove-ddt-dependency-only-used-for-testing.patch
)

python_compile_all() {
	distutils-r1_python_compile
	use doc && emake docs
}

python_install_all() {
	if use doc; then
		local HTML_DOCS=( doc/build/html/. )
		doman doc/build/man/reclass.1
	fi
	distutils-r1_python_install_all
}

python_test() {
	emake tests || die "Tests failed with ${EPYTHON}"
}
