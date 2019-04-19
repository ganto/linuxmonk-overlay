# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{3_5,3_6,3_7} )
VALA_USE_DEPEND="vapigen"

inherit gnome2 meson multilib-minimal python-any-r1 vala eutils

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="https://wiki.gnome.org/Projects/libsoup"

LICENSE="LGPL-2+"
SLOT="2.4"

IUSE="gssapi +introspection samba vala"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=dev-db/sqlite-3.8.2:3[${MULTILIB_USEDEP}]
	>=net-libs/glib-networking-2.38.2[ssl,${MULTILIB_USEDEP}]
	gssapi? ( virtual/krb5[${MULTILIB_USEDEP}] )
	>=dev-libs/gobject-introspection-0.9.5:=
	samba? ( net-fs/samba )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.20
	sys-devel/gettext
	>=net-libs/libpsl-0.20.0[${MULTILIB_USEDEP}]
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.40:2[${MULTILIB_USEDEP}]
	vala? ( $(vala_depend) )
"

src_prepare() {
	use vala && vala_src_prepare
	default
}

multilib_src_configure() {
	if multilib_is_native_abi; then
		local emesonargs=(
			$(meson_use gssapi)
			$(meson_use introspection)
			$(meson_use samba ntlm)
			$(meson_use vala vapi)
			$(usex samba -Dntlm_auth="'${EPREFIX}/usr/bin/ntlm_auth'" "")
		)
	else
		local emesonargs=(
			$(meson_use gssapi)
			-Dintrospection=false
			$(meson_use samba ntlm)
			-Dvapi=false
			$(usex samba -Dntlm_auth="'${EPREFIX}/usr/bin/ntlm_auth'" "")
		)
	fi
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}
