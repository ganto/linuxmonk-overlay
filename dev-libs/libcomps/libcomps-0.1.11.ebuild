# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit cmake-utils python-r1

DESCRIPTION="Comps XML file manipulation library"
HOMEPAGE="https://github.com/rpm-software-management/libcomps"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${P}.tar.gz"

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

S="${WORKDIR}/libcomps-${P}/libcomps"

libcomps_src_configure_internal() {
	local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
	mycmakeargs=( -DPYTHON_DESIRED=${python_major} )
	cmake-utils_src_configure
}

src_configure() {
	python_foreach_impl libcomps_src_configure_internal
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_install() {
	python_foreach_impl cmake-utils_src_install
}
