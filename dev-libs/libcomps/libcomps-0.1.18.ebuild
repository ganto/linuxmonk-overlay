# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit cmake python-r1

DESCRIPTION="Comps XML file manipulation library"
HOMEPAGE="https://github.com/rpm-software-management/libcomps"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/expat
	dev-libs/libxml2
	sys-libs/zlib
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
"

S="${WORKDIR}/${P}/libcomps"

src_configure() {
	python_foreach_impl cmake_src_configure
}

src_compile() {
	python_foreach_impl cmake_src_compile
}

libcomps_src_install_internal() {
	cmake_src_install
	python_optimize
}

src_install() {
	python_foreach_impl libcomps_src_install_internal
}
