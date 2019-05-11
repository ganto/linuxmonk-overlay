# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{5,6} )
VALA_USE_DEPEND="vapigen"

inherit gnome.org gnome2-utils meson vala distutils-r1 virtualx

DESCRIPTION="Library for aggregating people from multiple sources"
HOMEPAGE="https://wiki.gnome.org/Projects/Folks"

LICENSE="LGPL-2.1+"
SLOT="0/25" # subslot = libfolks soname version
KEYWORDS="~amd64"

IUSE="bluetooth eds +telepathy test tracker utils"
REQUIRED_USE="bluetooth? ( eds )"

COMMON_DEPEND="
	$(vala_depend)
	>=dev-libs/glib-2.44:2
	dev-libs/dbus-glib
	>=dev-libs/gobject-introspection-1.30:=
	>=dev-libs/libgee-0.10:0.8[introspection]
	dev-libs/libxml2
	sys-libs/ncurses:0=
	sys-libs/readline:0=

	bluetooth? ( >=net-wireless/bluez-5 )
	eds? ( >=gnome-extra/evolution-data-server-3.13.90:=[vala] )
	telepathy? ( >=net-libs/telepathy-glib-0.19.9[vala] )
	tracker? ( >=app-misc/tracker-1:0= )
"
# telepathy-mission-control needed at runtime; it is used by the telepathy
# backend via telepathy-glib's AccountManager binding.
RDEPEND="${COMMON_DEPEND}
	net-im/telepathy-mission-control
"
# FIXME:
# test? ( bluetooth? ( dbusmock is missing in the tree ) )
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPEND}
	sys-devel/gettext
	virtual/pkgconfig

	test? (
		sys-apps/dbus
		bluetooth? (
			>=gnome-extra/evolution-data-server-3.13.90
			>=dev-libs/glib-2.44:2
			dev-python/dbusmock[${PYTHON_USEDEP}] ) )
"

src_prepare() {
	default

	# Force re-generation of introspection files, otherwise it does not match installed libs
	find -name "*.vala" -exec touch {} \; || die
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use bluetooth bluez_backend)
		$(meson_use eds eds_backend)
		$(meson_use eds ofono_backend)
		$(meson_use telepathy telepathy_backend)
		$(meson_use tracker tracker_backend)
		$(meson_use utils import_tool)
		$(meson_use utils inspect_tool)
		-Ddocs=false
		-Dinstalled_tests=false
		-Dlibsocialweb_backend=false
		-Dzeitgeist=false
	)
	meson_src_configure
}

src_test() {

	virtx meson_src_test
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
