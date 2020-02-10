# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 pax-utils virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
IUSE="+cairo elibc_glibc examples gtk readline test"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/glib-2.58.0
	>=dev-libs/gobject-introspection-1.57.2:=

	elibc_glibc? ( >=dev-util/sysprof-3.34.0 )
	readline? ( sys-libs/readline:0= )
	dev-lang/spidermonkey:60
	virtual/libffi:=
	cairo? ( x11-libs/cairo[X] )
	gtk? ( >=x11-libs/gtk+-3.20:3 )
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

RESTRICT="!test? ( test )"

src_configure() {
	# FIXME: add systemtap/dtrace support, like in glib:2
	# FIXME: --enable-systemtap installs files in ${D}/${D} for some reason
	# XXX: Do NOT enable coverage, completely useless for portage installs
	gnome2_src_configure \
		--disable-systemtap \
		--disable-dtrace \
		--disable-code-coverage \
		$(use_enable elibc_glibc profiler) \
		$(use_with cairo cairo) \
		$(use_enable readline) \
		$(use_with test dbus-tests) \
		$(use_with test gtk-tests) \
		--disable-installed-tests
}

src_install() {
	# installation sometimes fails in parallel, bug #???
	gnome2_src_install -j1

	if use examples; then
		insinto /usr/share/doc/"${PF}"/examples
		doins "${S}"/examples/*
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}

src_test() {
	virtx dbus-run-session emake check || die
}
