# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 virtualx meson

DESCRIPTION="GNOME 3 compositing window manager based on Clutter"
HOMEPAGE="https://gitlab.gnome.org/GNOME/mutter/"

LICENSE="GPL-2+"
SLOT="0/2" # 0/libmutter_api_version - ONLY gnome-shell (or anything using mutter-clutter-<api_version>.pc) should use the subslot

IUSE="+gles2 input_devices_wacom +introspection udev wayland"
# native backend requires gles3 for hybrid graphics blitting support and a logind provider
# gles2 may be avoidable, but probably not worth the effort before switching to meson; without it, it seems it'll have subtle lost features as well that isn't explained to user atm.
REQUIRED_USE="wayland? ( gles2 )"

KEYWORDS="~amd64"

# libXi-1.7.4 or newer needed per:
# https://bugzilla.gnome.org/show_bug.cgi?id=738944
# gl.pc package is required, which is only installed by mesa if glx is enabled; pre-emptively requiring USE=X on mesa, as hopefully eventually it'll support disabling glx for wayland-only systems
RDEPEND="
	>=dev-libs/atk-2.5.3
	>=x11-libs/gdk-pixbuf-2:2
	>=dev-libs/json-glib-0.12.0
	>=x11-libs/pango-1.30[introspection?]
	>=x11-libs/cairo-1.14[X]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	>=dev-libs/glib-2.60.0:2[dbus]
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	>=gnome-base/gsettings-desktop-schemas-3.21.4[introspection?]
	gnome-base/gnome-desktop:3=
	>sys-power/upower-0.99:=

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.4
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	>=x11-libs/libXfixes-3
	>=x11-libs/libXi-1.7.4
	x11-libs/libXinerama
	>=x11-libs/libXrandr-1.5
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbfile
	>=x11-libs/libxkbcommon-0.4.3[X]
	x11-misc/xkeyboard-config

	gnome-extra/zenity
	media-libs/mesa[X(+),egl,gles2?]

	input_devices_wacom? ( >=dev-libs/libwacom-0.13 )
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
	udev? ( >=virtual/libgudev-232:= )
	wayland? (
		>=dev-libs/libinput-1.4
		>=dev-libs/wayland-1.13.0
		>=dev-libs/wayland-protocols-1.16
		>=media-libs/mesa-10.3[egl,gbm,wayland]
		sys-apps/systemd
		>=virtual/libudev-232:=
		x11-base/xorg-server[wayland]
		x11-libs/libdrm:=
	)

	media-video/pipewire
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	x11-base/xorg-proto
	test? ( app-text/docbook-xml-dtd:4.5 )
	wayland? ( >=sys-kernel/linux-headers-4.4 )
"

meson_use_enable() {
	usex "$1" "-D${2-$1}=enabled" "-D${2-$1}=disabled"
}

src_configure() {
	sed -i "/'-Werror=redundant-decls',/d" "${S}"/meson.build || die "sed failed"

	local emesonargs=(
		-Dopengl=true
		-Degl=true
		-Dglx=true
		-Dsm=true
		$(meson_use gles2)
		$(meson_use gles2 native_backend)
		$(meson_use wayland)
		$(meson_use udev)
		$(meson_use input_devices_wacom libwacom)
	)

	meson_src_configure
}
