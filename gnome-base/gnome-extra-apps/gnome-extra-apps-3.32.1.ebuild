# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+share +shotwell systemd +tracker"

KEYWORDS="~amd64"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# Keep pkg order within a USE flag as upstream releng versions file
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-3.32.0
	>=media-video/cheese-${PV}
	>=www-client/epiphany-${PV}.2
	>=app-arch/file-roller-${PV}
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-3.32.0
	>=gnome-extra/gnome-characters-${PV}
	>=gnome-extra/gnome-contacts-3.32
	>=sys-apps/gnome-disk-utility-${PV}
	>=media-gfx/gnome-font-viewer-3.32.0
	>=media-gfx/gnome-screenshot-3.32.0
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-weather-${PV}
	>=sci-geosciences/gnome-maps-${PV}
	>=gnome-extra/sushi-3.32.0
	>=net-misc/vino-3.22.0

	>=gnome-base/dconf-editor-3.32.0
	>=mail-client/evolution-${PV}
	>=gnome-extra/gnome-tweaks-3.32.0

	share? ( >=gnome-extra/gnome-user-share-3.32.0.1 )
	shotwell? ( >=media-gfx/shotwell-0.30.2 )
	systemd? ( >=gnome-extra/gnome-logs-${PV} )
	tracker? (
		>=app-misc/tracker-miners-2.1.5
		>=gnome-extra/gnome-documents-3.32.0
		>=media-gfx/gnome-photos-3.32.0
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
S=${WORKDIR}
