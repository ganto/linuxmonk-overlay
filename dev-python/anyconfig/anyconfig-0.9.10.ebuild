# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Common APIs to load and dump configuration files in various formats"
HOMEPAGE="https://github.com/ssato/python-anyconfig"
SRC_URI="https://github.com/ssato/python-anyconfig/archive/RELEASE_${PV}.tar.gz -> python-${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/jmespath[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/toml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.txt NEWS README.rst )

S="${WORKDIR}/python-${PN}-RELEASE_${PV}"

python_test() {
	${PYTHON} -m nose -v --all-modules --where tests || die "Tests failed with ${EPYTHON}"
}
