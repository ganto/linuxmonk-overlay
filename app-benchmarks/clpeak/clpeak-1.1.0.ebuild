# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A tool which profiles OpenCL devices to find their peak capacities"
HOMEPAGE="https://github.com/krrishnarraj/clpeak"
SRC_URI="https://github.com/krrishnarraj/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="results"

RDEPEND="dev-libs/ocl-icd"
DEPEND="${RDEPEND}
	dev-libs/boost"
BDEPEND=">=dev-libs/clhpp-2.0.12-r1"

PATCHES=( "${FILESDIR}"/1.1.0-Use-opencl-hpp-instead-of-cl-hpp.patch )

src_configure() {
	cmake_src_configure -Wno-dev
}

src_install() {
	dobin "${BUILD_DIR}"/clpeak
	dodoc README.md

	if use results; then
		docinto results/
		dodoc -r results/*
	fi
}
