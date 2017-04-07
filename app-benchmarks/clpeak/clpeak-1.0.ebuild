# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="A tool which profiles OpenCL devices to find their peak capacities"
HOMEPAGE="https://github.com/krrishnarraj/clpeak"
SRC_URI="https://github.com/krrishnarraj/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="results"

DEPEND="dev-libs/libffi
	media-libs/mesa[opencl]
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
"
RDEPEND="${DEPEND}"

src_install() {
	dobin "${BUILD_DIR}"/clpeak
	dodoc README.md STATUS

	if use results; then
		docinto results/
		dodoc -r results/*
	fi
}
