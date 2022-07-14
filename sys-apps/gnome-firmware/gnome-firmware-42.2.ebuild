# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg

DESCRIPTION="Graphical utility to query and update firmware on devices"
HOMEPAGE="https://gitlab.gnome.org/World/gnome-firmware"
SRC_URI="https://gitlab.gnome.org/World/${PN}/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd elogind"
REQUIRED_USE="|| ( elogind systemd )"

RDEPEND="
	dev-libs/appstream-glib
	>=dev-libs/libxmlb-0.1.7
	>=gui-libs/gtk-4.2:4
	gui-libs/libadwaita:1
	>=sys-apps/fwupd-1.7.5
	x11-themes/hicolor-icon-theme
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

src_configure() {
	local emesonargs=(
		-Dman=true
		$(meson_use elogind)
		$(meson_use systemd)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
