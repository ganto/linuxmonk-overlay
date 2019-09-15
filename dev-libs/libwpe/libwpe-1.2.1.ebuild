# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Library for WPE-flavored port of WebKit"
HOMEPAGE="https://github.com/WebPlatformForEmbedded/libwpe"
SRC_URI="https://github.com/WebPlatformForEmbedded/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	media-libs/mesa[egl]
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"
