# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org gnome2-utils meson vala

DESCRIPTION="Libraries for cryptographic UIs and accessing PKCS#11 modules"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gcr"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0/1" # subslot = suffix of libgcr-3

IUSE="gtk +introspection test vala"
RESTRICT="!test? ( test )"

KEYWORDS="~amd64"

DEPEND="
	app-crypt/gnupg
	>=app-crypt/p11-kit-0.19
	>=dev-libs/glib-2.44:2
	>=dev-libs/libgcrypt-1.2.2:0=
	>=dev-libs/libtasn1-1:=
	>=sys-apps/dbus-1
	gtk? ( >=x11-libs/gtk+-3.12:3[X,introspection?] )
	introspection? ( >=dev-libs/gobject-introspection-1.34:= )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.9
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	introspection? ( $(vala_depend) )
"

src_prepare() {
	eapply_user
	use introspection && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dgtk_doc=false
		$(meson_use gtk)
		$(meson_use introspection)
	)
	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
