# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1 virtualx

DESCRIPTION="Multiple GNOME terminals in one window"
HOMEPAGE="https://gnometerminator.blogspot.ch"
SRC_URI="https://launchpad.net/${PN}/gtk3/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus doc +libnotify"

RDEPEND="
	>=x11-libs/gtk+-3.16:3=
	>=dev-libs/glib-2.32:2=
	dev-libs/keybinder:0[python]
	dev-python/psutil
	x11-libs/vte:2.91
	dbus? ( sys-apps/dbus )
	libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )
"
DEPEND="
	dev-util/intltool
"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/0.90-without-icon-cache.patch
		"${FILESDIR}"/${PV}-desktop.patch
	)

	local i p
	if [[ -n "${LINGUAS+x}" ]] ; then
		pushd "${S}"/po > /dev/null
		strip-linguas -i .
		for i in *.po; do
			if ! has ${i%.po} ${LINGUAS} ; then
				rm ${i} || die
			fi
		done
		popd > /dev/null
	fi

	sed \
		-e "/'share', 'doc'/s:${PN}:${PF}:g" \
		-i setup.py terminatorlib/util.py || die

	use doc || \
		sed \
			-e '/install_documentation/s:True:False:g' \
			-i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	VIRTUALX_COMMAND="esetup.py"
	virtualmake test
}
