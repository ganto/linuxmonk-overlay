# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson virtualx

DESCRIPTION="GNOME 3 compositing window manager based on Clutter"
HOMEPAGE="https://gitlab.gnome.org/GNOME/mutter/"

LICENSE="GPL-2+"
SLOT="0/3" # 0/libmutter_api_version - ONLY gnome-shell (or anything using mutter-clutter-<api_version>.pc) should use the subslot

IUSE="debug elogind gles2 input_devices_wacom +introspection systemd test udev wayland"
# native backend requires gles3 for hybrid graphics blitting support and a logind provider
REQUIRED_USE="
	wayland? ( ^^ ( elogind systemd ) )"

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
	>=dev-libs/glib-2.60.0:2
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	>=gnome-base/gsettings-desktop-schemas-3.21.4[introspection?]
	gnome-base/gnome-desktop:3=

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
		>=media-libs/mesa-10.3[egl,gbm,wayland,gles2]
		systemd? ( sys-apps/systemd )
		elogind? ( sys-auth/elogind )
		>=virtual/libgudev-232:=
		>=virtual/libudev-136:=
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

src_prepare() {
	default
	# Work-around build-failure with >=gcc-8.3.0
	sed -e '/-Werror=empty-body/d' \
		-i meson.build || die
}

src_configure() {
	sed -i "/'-Werror=redundant-decls',/d" "${S}"/meson.build || die "sed failed"

	local emesonargs=(
		-Dopengl=true
		-Degl=true
		-Degl_device=true
		-Dglx=true
		-Dsm=true
		$(meson_use debug verbose)
		$(meson_use gles2)
		$(meson_use gles2 native_backend)
		$(meson_use introspection)
		$(meson_use wayland)
		$(meson_use udev)
		$(meson_use input_devices_wacom libwacom)
		$(meson_use test tests)
		$(meson_use test clutter_tests)
		$(meson_use test cogl_tests)
		-Dinstalled_tests=false
	)

	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
