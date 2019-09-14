# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.32"

inherit gnome.org meson vala

DESCRIPTION="Library providing a virtual terminal emulator widget"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/VTE"

LICENSE="LGPL-2+"
SLOT="2.91"
IUSE="+crypt debug +introspection vala vanilla"
KEYWORDS="~amd64 ~amd64-linux"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/fribidi-1.0.0
	>=dev-libs/glib-2.40:2
	>=dev-libs/libpcre2-10.21
	>=x11-libs/gtk+-3.16:3[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	sys-libs/zlib

	crypt?  ( >=net-libs/gnutls-3.2.7:0= )
	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig

	vala? ( $(vala_depend) )
"

src_prepare() {
	if ! use vanilla; then
		# Adds OSC 777 support for desktop notifications in gnome-terminal or elsewhere
		eapply "${FILESDIR}"/${PV}-cntnr-precmd-preexec-scroll.patch
	fi
	eapply_user

	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dfribidi=true
		-Dgtk3=true
		-Diconv=true
		$(meson_use crypt gnutls)
		$(meson_use debug debugg)
		$(meson_use introspection gir)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	mv "${ED}"/etc/profile.d/vte{,-${SLOT}}.sh || die
}
