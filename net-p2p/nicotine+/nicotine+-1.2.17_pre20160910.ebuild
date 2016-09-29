# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

MY_COMMIT="c95471e30ed39adbe3d606830f02a2a40056315e"

inherit distutils-r1

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://nicotine-plus.sourceforge.net"
SRC_URI="https://github.com/eLvErDe/nicotine-plus/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip metadata upnp"

RDEPEND="
	geoip? ( dev-python/geoip-python )
	>=dev-python/pygtk-2.24:2[${PYTHON_USEDEP}]
	metadata? ( media-libs/mutagen )
	upnp? ( net-libs/miniupnpc )
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/nicotine-plus-${MY_COMMIT}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e "s:share/doc/nicotine:share/doc/${P}:" \
			"${S}"/setup.py \
			"${S}"/pynicotine/gtkgui/frame.py
}

python_install_all() {
	insinto /usr/share/nicotine
	doins -r plugins
	distutils-r1_python_install_all
}

src_install() {
	distutils-r1_src_install
	python_fix_shebang "${D}"
	dosym nicotine.py /usr/bin/nicotine
}

pkg_postinst() {
	elog "Plugins can be enabled by copying them into your local directory. E.g.:"
	elog "  cp -r /usr/share/nicotine/plugins/* ~/.nicotine/plugins/"
}
