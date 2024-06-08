# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_PN="python-${PN%%-python}4"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python SDK for oVirt Engine API"
HOMEPAGE="
	https://www.ovirt.org/
	https://github.com/oVirt/python-ovirt-engine-sdk4
"
SRC_URI="https://github.com/oVirt/python-ovirt-engine-sdk4/archive/${PV}/${MY_P}.tar.gz -> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="
	dev-libs/libxml2
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

# needs local ovirt instance to run tests
RESTRICT="
	mirror
	test
"

DOCS=( README.adoc )

src_prepare() {
	default

	find examples -type f -print0 | xargs -0 chmod 0644
	GENERATED_FILES="
		lib/ovirtsdk4/version.py
		setup.py
		PKG-INFO
		lib/ovirt_engine_sdk_python.egg-info/PKG-INFO
	"
	for gen_file in ${GENERATED_FILES}; do
		sed -e "s|@RPM_VERSION@|${PV}|g" < ${gen_file}.in > ${gen_file}
	done
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto /usr/share/doc/${PF}/examples
		dodoc -r examples/*
	fi
}
