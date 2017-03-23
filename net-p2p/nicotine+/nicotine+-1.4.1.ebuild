# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://github.com/Nicotine-Plus"
SRC_URI="https://github.com/Nicotine-Plus/nicotine-plus/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="geoip metadata upnp"

RDEPEND="
	geoip? ( dev-python/geoip-python[${PYTHON_USEDEP}] )
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	>=dev-python/pygtk-2.24:2[${PYTHON_USEDEP}]
	metadata? ( >=media-libs/mutagen-1.25[${PYTHON_USEDEP}] )
	upnp? ( net-libs/miniupnpc )
	x11-misc/xdg-utils
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/nicotine-plus-${PV}"

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

pkg_postinst() {
	elog "Plugins can be enabled by copying them into your local directory. E.g.:"
	elog "  cp -r /usr/share/nicotine/plugins/* ~/.nicotine/plugins/"
}
