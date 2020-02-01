# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit gnome.org gnome2-utils meson python-single-r1 vala virtualx

DESCRIPTION="A GObject plugins library"
HOMEPAGE="https://developer.gnome.org/libpeas/stable/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+gtk glade lua luajit +python vala"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.38:2
	>=dev-libs/gobject-introspection-1.39:=
	glade? ( >=dev-util/glade-3.9.1:3.10 )
	gtk? ( >=x11-libs/gtk+-3:3[introspection] )
	lua? (
		>=dev-lua/lgi-0.9.0
		luajit? ( >=dev-lang/luajit-2:2 )
		!luajit? ( =dev-lang/lua-5.1*:0 ) )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.2:3[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	eapply_user
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Ddemos=false
		-Dintrospection=true
		-Dpython2=false
		$(meson_use glade glade_catalog)
		$(meson_use gtk widgetry)
		$(meson_use lua lua51)
		$(meson_use python python3)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
