# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+share systemd +tracker"

KEYWORDS="~amd64"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# Keep pkg order within a USE flag as upstream releng versions file
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-${PV}
	>=media-video/cheese-${PV}
	>=www-client/epiphany-${PV}
	>=app-arch/file-roller-3.32.2
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-3.32.1
	>=gnome-extra/gnome-clocks-${PV}
	>=gnome-extra/gnome-contacts-3.34
	>=sys-apps/gnome-disk-utility-${PV}
	>=media-gfx/gnome-font-viewer-${PV}
	>=media-gfx/gnome-screenshot-3.32.0
	>=gnome-extra/gnome-system-monitor-3.32.1
	>=gnome-extra/gnome-weather-3.32.2
	>=sci-geosciences/gnome-maps-${PV}
	>=gnome-extra/sushi-${PV}
	>=net-misc/vino-3.22.0

	>=gnome-base/dconf-editor-${PV}
	>=mail-client/evolution-${PV}
	>=gnome-extra/gnome-tweaks-3.32.0

	share? ( >=gnome-extra/gnome-user-share-${PV} )
	systemd? ( >=gnome-extra/gnome-logs-${PV} )
	tracker? (
		>=app-misc/tracker-miners-2.3.0
		>=media-gfx/gnome-photos-${PV}
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
S=${WORKDIR}
