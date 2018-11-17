# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org meson

DESCRIPTION="The Eye of GNOME image viewer"
HOMEPAGE="https://wiki.gnome.org/Apps/EyeOfGnome"

LICENSE="GPL-2+"
SLOT="1"

IUSE="debug +exif +introspection +jpeg lcms +svg tiff xmp"
REQUIRED_USE="exif? ( jpeg )"

KEYWORDS="~amd64"

RDEPEND="
	>=dev-libs/glib-2.42.0:2[dbus]
	>=dev-libs/libpeas-0.7.4:=[gtk]
	>=gnome-base/gnome-desktop-2.91.2:3=
	>=gnome-base/gsettings-desktop-schemas-2.91.92
	>=x11-libs/gtk+-3.19.11:3[introspection,X]
	>=x11-misc/shared-mime-info-0.20

	>=x11-libs/gdk-pixbuf-2.30.0:2[jpeg?,tiff?]
	x11-libs/libX11

	exif? ( >=media-libs/libexif-0.6.14 )
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	jpeg? ( virtual/jpeg:0 )
	lcms? ( media-libs/lcms:2 )
	svg? ( >=gnome-base/librsvg-2.36.2:2 )
	xmp? ( media-libs/exempi:2 )
"
DEPEND="${RDEPEND}
	media-libs/exempi:2
	>=dev-util/gtk-doc-am-1.16
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use exif libexif)
		$(meson_use introspection)
		$(meson_use jpeg libjpeg)
		$(meson_use lcms cms)
		$(meson_use svg librsvg)
		$(meson_use xmp)
	)

	meson_src_configure
}
