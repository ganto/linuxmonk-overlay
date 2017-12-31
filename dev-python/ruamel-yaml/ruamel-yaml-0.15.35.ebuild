# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="YAML 1.2 loader/dumper package for Python"
HOMEPAGE="https://pypi.python.org/pypi/ruamel.yaml"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/typing[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/ruamel-ordereddict[${PYTHON_USEDEP}]' 'python2_7')
"
DEPEND="
	dev-libs/libyaml
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGES README.rst )

python_install() {
	esetup.py install --single-version-externally-managed --skip-build --root "${D}"
}
