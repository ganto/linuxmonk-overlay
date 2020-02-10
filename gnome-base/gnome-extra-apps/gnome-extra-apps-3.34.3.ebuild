# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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

	>=sys-apps/baobab-3.34.0
	>=media-video/cheese-3.34.0
	>=www-client/epiphany-${PV}.1
	>=app-arch/file-roller-3.32.3
	>=gnome-extra/gnome-calculator-3.34.1
	>=gnome-extra/gnome-calendar-3.34.2
	>=gnome-extra/gnome-characters-3.32.1
	>=gnome-extra/gnome-clocks-3.34.0
	>=gnome-extra/gnome-contacts-3.34.1
	>=sys-apps/gnome-disk-utility-3.34.0
	>=media-gfx/gnome-font-viewer-3.34.0
	>=media-gfx/gnome-screenshot-3.34.0
	>=gnome-extra/gnome-system-monitor-3.32.1
	>=gnome-extra/gnome-weather-3.34.0
	>=sci-geosciences/gnome-maps-${PV}
	>=gnome-extra/sushi-3.34.0

	>=gnome-base/dconf-editor-3.34.2
	>=mail-client/evolution-${PV}
	>=gnome-extra/gnome-tweaks-3.34.0

	share? ( >=gnome-extra/gnome-user-share-3.34.0 )
	systemd? ( >=gnome-extra/gnome-logs-3.34.0 )
	tracker? (
		>=app-misc/tracker-2.3.1
		>=app-misc/tracker-miners-2.3.1
		>=media-gfx/gnome-photos-3.34.0
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
BDEPEND=""
S=${WORKDIR}
