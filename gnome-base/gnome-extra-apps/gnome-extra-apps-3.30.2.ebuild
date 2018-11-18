# Copyright 1999-2018 Gentoo Foundation
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

	>=sys-apps/baobab-3.30.0
	>=media-video/cheese-3.30.0
	>=www-client/epiphany-${PV}
	>=app-arch/file-roller-3.30.1
	>=gnome-extra/gnome-calculator-3.30.1
	>=gnome-extra/gnome-calendar-3.30.0
	>=gnome-extra/gnome-characters-3.30.0
	>=gnome-extra/gnome-contacts-3.30.1
	>=sys-apps/gnome-disk-utility-${PV}
	>=media-gfx/gnome-font-viewer-3.30.0
	>=media-gfx/gnome-screenshot-3.30.0
	>=gnome-extra/gnome-system-monitor-3.30.0
	>=gnome-extra/gnome-weather-3.26.0
	>=sci-geosciences/gnome-maps-${PV}
	>=gnome-extra/sushi-3.30.0
	>=net-misc/vino-3.22.0

	>=gnome-base/dconf-editor-3.30.1
	>=mail-client/evolution-${PV}
	>=gnome-extra/gnome-tweaks-3.30.1

	share? ( >=gnome-extra/gnome-user-share-3.28.0 )
	shotwell? ( >=media-gfx/shotwell-0.30 )
	systemd? ( >=gnome-extra/gnome-logs-3.30.0 )
	tracker? (
		>=app-misc/tracker-miners-2.1.5
		>=gnome-extra/gnome-documents-3.30.0
		>=media-gfx/gnome-photos-3.30.1
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
S=${WORKDIR}
