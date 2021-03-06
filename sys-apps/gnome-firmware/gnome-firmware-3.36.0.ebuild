# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg

DESCRIPTION="Graphical utility to query and update firmware on devices"
HOMEPAGE="https://gitlab.gnome.org/hughsie/gnome-firmware-updater"
SRC_URI="https://gitlab.gnome.org/hughsie/${PN}-updater/-/archive/${PV}/${PN}-updater-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd elogind"
REQUIRED_USE="|| ( elogind systemd )"

RDEPEND="
	dev-libs/appstream-glib
	>=dev-libs/libxmlb-0.1.7
	>=net-libs/libsoup-2.51.92
	>=sys-apps/fwupd-1.2.10
	>=x11-libs/gtk+-3.11.2:3
	elogind? ( >=sys-auth/elogind-211 )
	systemd? ( >=sys-apps/systemd-211 )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

S="${WORKDIR}"/${PN}-updater-${PV}

src_configure() {
	local emesonargs=(
		-Dconsolekit=false
		-Dman=false
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
