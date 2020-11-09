# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="libportal provides GIO-style async APIs for most Flatpak portals"
HOMEPAGE="https://flatpak.org/ https://github.com/flatpak/libportal"
SRC_URI="https://github.com/flatpak/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk-doc"

DEPEND="dev-libs/glib:2"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-util/meson-0.46.0
	dev-util/glib-utils
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3 )
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/0.3.0-build-optional-gtkdoc.patch )

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc)
	)
	meson_src_configure
}
