# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Gnome session manager"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-session"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="consolekit doc elogind systemd"
# There is a null backend available, thus ?? not ^^
# consolekit can be enabled alone, or together with a logind provider; in latter case CK is used as fallback
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	>=dev-libs/glib-2.58.0:2[dbus]
	>=x11-libs/gtk+-3.18.0:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=gnome-base/gnome-desktop-3.27.90:3=
	>=dev-libs/json-glib-0.10
	media-libs/mesa[egl,gles2,X(+)]
	media-libs/libepoxy
	x11-libs/libXcomposite

	systemd? ( >=sys-apps/systemd-183:0= )
	elogind? ( >=sys-auth/elogind-239.4 )
	consolekit? ( >dev-libs/dbus-glib-0.76 )
"

# Pure-runtime deps from the session files should *NOT* be added here
# Otherwise, things like gdm pull in gnome-shell
# gnome-settings-daemon is assumed to be >=3.27.90, but this is about
# removed components, so no need to strictly require it (older just
# won't have those daemons loaded by gnome-session).
# sys-apps/dbus[X] is needed for session management.
RDEPEND="${DEPEND}
	>=gnome-base/gnome-settings-daemon-3.23.3
	>=gnome-base/gsettings-desktop-schemas-3.28.1
	x11-themes/adwaita-icon-theme
	sys-apps/dbus[X]
	consolekit? ( sys-auth/consolekit )

	x11-misc/xdg-user-dirs
	x11-misc/xdg-user-dirs-gtk
"
BDEPEND="
	dev-libs/libxslt
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.19.8
	x11-libs/xtrans
	virtual/pkgconfig
	!<gnome-base/gdm-2.20.4
	doc? ( app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2 )
"

PATCHES=(
	"${FILESDIR}"/3.36.0-elogind-support.patch
)

src_prepare() {
	xdg_src_prepare
	# Install USE=doc in $PF if enabled
	sed -i -e "s:meson\.project_name(), 'dbus':'${PF}', 'dbus':" doc/dbus/meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddeprecation_flags=false
		$(meson_use elogind)
		$(meson_use systemd)
		$(meson_use systemd systemd_journal)
		$(meson_use consolekit)
		$(meson_use doc docbook)
		-Dman=true
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version gnome-base/gdm && ! has_version x11-misc/sddm; then
		ewarn "If you use a custom .xinitrc for your X session,"
		ewarn "make sure that the commands in the xinitrc.d scripts are run."
	fi

	if ! use systemd && ! use elogind && ! use consolekit; then
		ewarn "You are building without systemd, elogind and/or consolekit support."
		ewarn "gnome-session won't be able to correctly track and manage your session."
	fi
}

pkg_postrm() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
