# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
#DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A recursive external node classifier for automation tools"
HOMEPAGE="https://github.com/salt-formulas/reclass"
SRC_URI="https://github.com/salt-formulas/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? ( dev-python/sphinx )
	test? (
		dev-python/ddt[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/${PV}-Fix-class_mappings-regression.patch" )

python_compile_all() {
	default

	if use doc; then
		pushd doc
		emake man html
		popd
	fi
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
