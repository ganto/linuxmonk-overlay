# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Your Debian-based data center in a box"
HOMEPAGE="https://debops.org"
SRC_URI="https://github.com/debops/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RDEPEND="app-admin/ansible
	dev-python/netaddr"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/debops-tools-${PV}"

DOCS=( CHANGES.rst CONTRIBUTING.rst README.rst )

python_compile_all() {
	if use doc; then
		cp "${FILESDIR}"/conf.py docs/
		${PYTHON} setup.py build_sphinx
	fi
}

python_test() {
	nosetests || die "Tests failed"
}

python_install_all() {
	use doc && local HTML_DOCS=( build/sphinx/html/. )
	distutils-r1_python_install_all
}
