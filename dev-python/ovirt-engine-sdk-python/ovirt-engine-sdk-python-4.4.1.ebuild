# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

MY_PN="${PN%%-python}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python SDK for oVirt Engine API"
HOMEPAGE="https://www.ovirt.org/ https://github.com/oVirt/ovirt-engine-sdk"
SRC_URI="https://github.com/oVirt/${MY_PN}/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples"

DEPEND="
	dev-libs/libxml2
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	virtual/python-enum34[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

DOCS=( README.adoc CHANGES.adoc )

S="${WORKDIR}/${MY_P}/sdk"

src_prepare() {
	cp "${FILESDIR}"/${PV}-version.py lib/ovirtsdk4/version.py || die
	default
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
