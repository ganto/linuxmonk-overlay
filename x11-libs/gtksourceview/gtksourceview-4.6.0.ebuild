# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.24"
VALA_USE_DEPEND="vapigen"

inherit gnome.org gnome2-utils meson vala

DESCRIPTION="A text widget implementing syntax highlighting and other features"
HOMEPAGE="https://wiki.gnome.org/Projects/GtkSourceView"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="4"

IUSE="glade +introspection test +vala"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~amd64"

DEPEND="
	>=dev-libs/glib-2.48:2
	>=dev-libs/libxml2-2.6:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	glade? ( >=dev-util/glade-3.9:3.10 )
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
	>=dev-libs/fribidi-0.19.7
"
RDEPEND="${DEPEND}"
DEPEND="
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use glade glade_catalog)
		-Dgtk_doc=false
		-Dinstall_tests=false
		$(meson_use introspection gir)
		$(meson_use vala vapi)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	insinto /usr/share/${PN}-4/language-specs
	doins "${FILESDIR}"/2.0/gentoo.lang

	# Avoid conflict with gtksourceview:3.0 glade-catalog
	# TODO: glade doesn't actually show multiple GtkSourceView widget collections, so with both installed, can't really be sure which ones are used
	if use glade; then
		mv "${ED}"/usr/share/glade/catalogs/gtksourceview.xml "${ED}"/usr/share/glade/catalogs/gtksourceview-${SLOT}.xml || die
	fi
}
