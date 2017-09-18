# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

PLOCALES="af ar ast az be be@latin bg bn bs ca cs csb cy da de el en en_AU en_CA en_GB eo es et eu fa fi fo fr frp fy gl gu he hi hr hu id it ja ka kk ko lt lv mk ml ms nb nl oc pl pt pt_BR ro ru sc si sk sl sq sr sv sw ta te th tl tr ts uk ur vi zh zh_CN zh_TW"

inherit l10n python-r1 xdg-utils

MY_PV="${PV/_/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="a media player aiming to be similar to AmaroK, but for GTK+"
HOMEPAGE="http://www.exaile.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cddb lastfm libnotify lyrics musicbrainz nls podcast"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gst-python:1.0[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.13:3[${PYTHON_USEDEP}]
	>=media-libs/gstreamer-1.4:1.0
	>=media-libs/gst-plugins-base-1.6:1.0
	>=media-libs/gst-plugins-good-1.4:1.0
	>=media-libs/mutagen-1.10
	>=x11-libs/gtk+-3.10:3
	cddb? ( dev-python/cddb-py[${PYTHON_USEDEP}] )
	lastfm? ( dev-python/pylast[${PYTHON_USEDEP}] )
	libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )
	lyrics? ( dev-python/beautifulsoup:4[${PYTHON_USEDEP}] )
	musicbrainz? ( dev-python/python-musicbrainz-ngs[${PYTHON_USEDEP}] )
	podcast? ( dev-python/feedparser[${PYTHON_USEDEP}] )"
DEPEND="
	${PYTHON_DEPS}
	nls? (
		dev-util/intltool
		sys-devel/gettext
	)"

RESTRICT="test" #315589

S="${WORKDIR}/${MY_P}"

remove_locale() {
	find "${S}/po" -name "${1}.po" -delete || die "Failed to remove locale ${1}."
}

src_prepare() {
	eapply_user

	if use nls; then
		l10n_for_each_disabled_locale_do remove_locale
	fi
}

src_compile() {
	# make sure Python 2 is used
	python_setup

	emake all$(use nls || echo _no_locale)
}

src_install() {
	echo S=${S}
	find "${S}" -name exaile.mo
	emake \
		PREFIX=/usr \
		LIBINSTALLDIR="\$(PREFIX)/$(get_libdir)" \
		DESTDIR="${D}" \
		install$(use nls || echo _no_locale)
}

pkg_postinst() {
	fdo-xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	fdo-xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
