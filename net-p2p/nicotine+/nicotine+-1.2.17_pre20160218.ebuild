# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

EGIT_REPO_URI="https://github.com/eLvErDe/nicotine-plus.git"
EGIT_COMMIT="eaa4a915316737548d32f37a22f4925e3624531d"

inherit distutils-r1 git-r3

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://nicotine-plus.sourceforge.net"
SRC_URI=""

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip metadata upnp"

RDEPEND="
	geoip? ( dev-python/geoip-python )
	>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
	metadata? ( media-libs/mutagen )
	upnp? ( net-libs/miniupnpc )
"

DEPEND="${RDEPEND}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e 's:\(Icon=\).*:\1nicotine-plus-32px:' \
			"${S}"/files/nicotine.desktop
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${D}"
	dosym nicotine.py /usr/bin/nicotine
}
