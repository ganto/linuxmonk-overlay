# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit gnome.org gnome2-utils meson udev vala

DESCRIPTION="GObject library for managing information about real and virtual OSes"
HOMEPAGE="https://libosinfo.org/"
SRC_URI="https://releases.pagure.org/libosinfo/${P}.tar.xz"
RESTRICT="mirror"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

IUSE="gtk-doc +introspection +vala test"
RESTRICT="!test? ( test )"
REQUIRED_USE="vala? ( introspection )"

KEYWORDS="~amd64"

# Unsure about osinfo-db-tools rdep, but at least fedora does it too
RDEPEND="
	>=dev-libs/glib-2.44.0:2
	>=dev-libs/libxml2-2.6.0
	>=dev-libs/libxslt-1.0.0
	net-libs/libsoup:2.4
	sys-apps/hwids[pci,usb]
	sys-apps/osinfo-db-tools
	sys-apps/osinfo-db
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
# perl dep is for pod2man, and configure.ac checks for it too now
BDEPEND="
	dev-lang/perl
	dev-libs/gobject-introspection-common
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? ( dev-util/gtk-doc )
	vala? ( $(vala_depend) )
"

src_prepare() {
	default
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Denable-gtk-doc=false
		-Dwith-pci-ids-path=/usr/share/misc/pci.ids
		-Dwith-usb-ids-path=/usr/share/misc/usb.ids
		$(meson_use gtk-doc enable-gtk-doc)
		$(meson_use test enable-tests)
	)
	if use introspection; then
		emesonargs+=( -Denable-introspection=enabled )
	else
		emesonargs+=( -Denable-introspection=disabled )
	fi
	if use vala; then
		emesonargs+=( -Denable-vala=enabled )
	else
		emesonargs+=( -Denable-vala=disabled )
	fi

	meson_src_configure
}
