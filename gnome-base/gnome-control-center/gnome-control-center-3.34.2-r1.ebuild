# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="GNOME's main interface to configure various aspects of the desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-control-center/"

LICENSE="GPL-2+"
SLOT="2"
IUSE="debug +ibus v4l wayland"
KEYWORDS="~amd64"

COMMON_DEPEND="
	>=gui-libs/libhandy-0.0.10:0.0=
	>=net-libs/gnome-online-accounts-3.25.3:=
	>=media-sound/pulseaudio-2.0[glib]
	>=sys-apps/accountsservice-0.6.39
	>=x11-misc/colord-0.1.34:0=
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=dev-libs/glib-2.53.0:2
	>=gnome-base/gnome-desktop-3.27.90:3=
	>=gnome-base/gnome-settings-daemon-3.27.90[colord,input_devices_wacom]
	>=gnome-base/gsettings-desktop-schemas-3.31.0
	dev-libs/libxml2:2
	>=sys-auth/polkit-0.114
	>=sys-power/upower-0.99.8:=
	x11-libs/libX11
	>=x11-libs/libXi-1.2
	>=media-libs/grilo-0.3.0:0.3=
	>=x11-libs/gtk+-3.22.20:3[X,wayland=]
	>=net-print/cups-1.7[dbus]
	>=net-fs/samba-4.0.0[client]
	v4l? (
		>=media-video/cheese-3.28.0 )
	ibus? ( >=app-i18n/ibus-1.5.2 )
	wayland? ( dev-libs/libgudev )
	>=gnome-extra/nm-applet-1.8.0
	>=net-misc/networkmanager-1.12.0:=[modemmanager]
	>=net-misc/modemmanager-0.7.990
	>=net-wireless/gnome-bluetooth-3.18.2:=
	>=dev-libs/libwacom-0.7
	app-crypt/mit-krb5

	x11-libs/cairo[glib]
	>=x11-libs/colord-gtk-0.1.24
	net-libs/libsoup:2.4
	media-libs/fontconfig
	gnome-base/libgtop:2=
	>=sys-fs/udisks-2.1.8:2
	app-crypt/libsecret
	>=media-libs/gsound-1.0.2
	>=dev-libs/libpwquality-1.2.2
"
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
# libgnomekbd needed only for gkbd-keyboard-display tool
#
# mouse panel needs a concrete set of X11 drivers at runtime, bug #580474
# Also we need newer driver versions to allow wacom and libinput drivers to
# not collide
RDEPEND="${COMMON_DEPEND}
	|| ( >=sys-apps/systemd-31 ( app-admin/openrc-settingsd sys-auth/consolekit ) )
	x11-themes/adwaita-icon-theme
	>=gnome-extra/gnome-color-manager-3.28.0
	app-admin/system-config-printer
	net-print/cups-pk-helper
	>=gnome-base/libgnomekbd-3
	wayland? ( dev-libs/libinput )
	!wayland? (
		>=x11-drivers/xf86-input-libinput-0.19.0
		>=x11-drivers/xf86-input-wacom-0.33.0 )
	media-plugins/grilo-plugins:0.3[flickr,gnome-online-accounts]

	!<gnome-base/gdm-2.91.94
	!gnome-extra/gnome-media[pulseaudio]
	!<gnome-extra/gnome-media-2.32.0-r300
	!<net-wireless/gnome-bluetooth-3.3.2
"
# PDEPEND to avoid circular dependency
PDEPEND=">=gnome-base/gnome-session-2.91.6-r1"

DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
	app-text/docbook-xml-dtd:4.2
	x11-base/xorg-proto
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use v4l cheese)
		-Ddocumentation=true # manpage
		$(meson_use ibus)
		$(meson_use debug tracing)
		$(meson_use wayland)
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
