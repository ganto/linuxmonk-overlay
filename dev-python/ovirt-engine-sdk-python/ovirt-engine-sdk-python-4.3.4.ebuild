# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

MY_PN="${PN%%-python}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python SDK for oVirt Engine API"
HOMEPAGE="https://www.ovirt.org/ https://github.com/oVirt/ovirt-engine-sdk"
SRC_URI="https://resources.ovirt.org/pub/ovirt-4.3-pre/src/python-ovirt-engine-sdk4/${P}.tar.gz"
RESTRICT="mirror"

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

DOCS=( README.adoc )

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
