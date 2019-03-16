# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.39"

inherit gnome2 bash-completion-r1 virtualx meson vala

DESCRIPTION="Simple low-level configuration system"
HOMEPAGE="https://wiki.gnome.org/action/show/Projects/dconf"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.53.4:2
	sys-apps/dbus
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.15
	sys-devel/gettext
	app-shells/bash-completion
	virtual/pkgconfig
	$(vala_depend)
"

src_prepare() {
	vala_src_prepare
	default
}

src_install() {
	meson_src_install

	# GSettings backend may be one of: memory, gconf, dconf
	# Only dconf is really considered functional by upstream
	# must have it enabled over gconf if both are installed
	echo 'CONFIG_PROTECT_MASK="/etc/dconf"' >> 51dconf
	echo 'GSETTINGS_BACKEND="dconf"' >> 51dconf
	doenvd 51dconf
}

pkg_postinst() {
	gnome2_pkg_postinst
	# Kill existing dconf-service processes as recommended by upstream due to
	# possible changes in the dconf private dbus API.
	# dconf-service will be dbus-activated on next use.
	pids=$(pgrep -x dconf-service)
	if [[ $? == 0 ]]; then
		ebegin "Stopping dconf-service; it will automatically restart on demand"
		kill ${pids}
		eend $?
	fi
}
