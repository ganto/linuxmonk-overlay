# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-settings-daemon-${PV}
	>=gnome-base/gnome-control-center-${PV}.1
	>=gnome-extra/gnome-color-manager-3.32.0

	>=app-crypt/gcr-3.28.1
	>=gnome-base/nautilus-${PV}
	>=gnome-base/gnome-keyring-3.28.2
	>=gnome-extra/evolution-data-server-${PV}

	>=app-crypt/seahorse-3.32.2
	>=app-editors/gedit-${PV}
	>=app-text/evince-3.32.0
	>=gnome-extra/gnome-contacts-3.34
	>=media-gfx/eog-${PV}
	>=media-video/totem-${PV}
	>=x11-terms/gnome-terminal-${PV}

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-${PV}

	>=x11-themes/adwaita-icon-theme-${PV}

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.32.1 )
"
DEPEND=""

S="${WORKDIR}"