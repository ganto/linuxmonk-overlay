# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+bluetooth cups"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64"

# gnome-color-manager min version enforced here due to control-center pulling it in
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-3.36.0
	>=gnome-base/gnome-settings-daemon-3.36.0[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups?]
	>=gnome-extra/gnome-color-manager-3.35.90

	>=app-crypt/gcr-3.36.0
	>=gnome-base/nautilus-${PV}.1
	>=gnome-base/gnome-keyring-3.36.0
	>=gnome-extra/evolution-data-server-${PV}

	>=app-crypt/seahorse-3.36
	>=app-editors/gedit-${PV}
	>=app-text/evince-3.36.0
	>=gnome-extra/gnome-contacts-3.36
	>=media-gfx/eog-${PV}
	>=media-video/totem-3.34.1
	>=x11-terms/gnome-terminal-${PV}.1

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-3.36.0

	>=x11-themes/adwaita-icon-theme-3.36.0

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.34.1 )
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"
