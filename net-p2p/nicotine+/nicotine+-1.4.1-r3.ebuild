# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A fork of nicotine, a Soulseek client in Python"
HOMEPAGE="https://github.com/Nicotine-Plus/nicotine-plus"
SRC_URI="https://github.com/Nicotine-Plus/nicotine-plus/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="geoip metadata upnp"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/pygtk-2.24:2[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:2[${PYTHON_MULTI_USEDEP}]
		geoip? ( dev-python/geoip-python[${PYTHON_MULTI_USEDEP}] )
		metadata? ( >=media-libs/mutagen-1.25[${PYTHON_MULTI_USEDEP}] )
	')
	upnp? ( net-libs/miniupnpc )
	x11-misc/xdg-utils
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/nicotine-plus-${PV}"

src_prepare() {
	distutils-r1_src_prepare
	sed -i -e "s:share/doc/nicotine:share/doc/${PF}:" \
			"${S}"/setup.py \
			"${S}"/pynicotine/gtkgui/frame.py
}

src_install() {
	distutils-r1_src_install
	insinto /usr/share/nicotine
	doins -r plugins
}

pkg_postinst() {
	elog "Plugins can be enabled by copying them into your local directory. E.g.:"
	elog "  cp -r /usr/share/nicotine/plugins/* ~/.nicotine/plugins/"
}
