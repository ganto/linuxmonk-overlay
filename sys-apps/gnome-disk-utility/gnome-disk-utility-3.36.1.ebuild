# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Disk Utility for GNOME using udisks"
HOMEPAGE="https://wiki.gnome.org/Apps/Disks"

LICENSE="GPL-2+"
SLOT="0"
IUSE="fat elogind gnome systemd"
REQUIRED_USE="?? ( elogind systemd )"
KEYWORDS="~amd64"

COMMON_DEPEND="
	>=dev-libs/glib-2.31:2
	>=sys-fs/udisks-2.7.6:2
	>=x11-libs/gtk+-3.16.0:3
	>=app-crypt/libsecret-0.7
	>=dev-libs/libpwquality-1.0.0
	>=media-libs/libcanberra-0.1[gtk3]
	>=media-libs/libdvdread-4.2.0:0=
	>=x11-libs/libnotify-0.7:=
	>=app-arch/xz-utils-5.0.5
	elogind? ( >=sys-auth/elogind-209 )
	systemd? ( >=sys-apps/systemd-209:0= )
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
	fat? ( sys-fs/dosfstools )
	gnome? ( >=gnome-base/gnome-settings-daemon-3.8 )
"
# appstream-glib for developer_name tag in appdata (gettext-0.19.8.1 own appdata.its file doesn't have it yet)
# libxml2 for xml-stripblanks in gresource
DEPEND="${COMMON_DEPEND}
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-libs/libxslt
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dman=true
		$(meson_use gnome gsd_plugin)
	)
	if use systemd; then
		emesonargs+=(-Dlogind=libsystemd)
	else
		if use elogind; then
			emesonargs+=(-Dlogind=libelogind)
		else
			emesonargs+=(-Dlogind=none)
		fi
	fi
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
