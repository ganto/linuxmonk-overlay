# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="share +shotwell systemd +tracker"

KEYWORDS="~amd64"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# Keep pkg order within a USE flag as upstream releng versions file
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-${PV}
	>=media-video/cheese-3.38.0
	>=www-client/epiphany-${PV}
	>=app-arch/file-roller-3.38.0
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-${PV}
	>=gnome-extra/gnome-clocks-${PV}
	>=gnome-extra/gnome-contacts-${PV}
	>=sys-apps/gnome-disk-utility-${PV}
	>=media-gfx/gnome-font-viewer-${PV}
	>=media-gfx/gnome-screenshot-${PV}
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-weather-${PV}
	>=gnome-extra/gucharmap-13.0.6:2.90
	>=sci-geosciences/gnome-maps-${PV}
	>=gnome-extra/sushi-3.38.0
	>=media-sound/sound-juicer-3.38.0

	>=gnome-base/dconf-editor-3.38.3
	>=app-dicts/gnome-dictionary-${PV}
	>=mail-client/evolution-3.40.0
	>=gnome-extra/gnome-tweaks-${PV}
	>=gnome-extra/nautilus-sendto-3.8.6
	>=net-misc/vinagre-3.22.0

	share? ( >=gnome-extra/gnome-user-share-3.34.0 )
	shotwell? ( >=media-gfx/shotwell-0.30.11 )
	systemd? ( >=gnome-extra/gnome-logs-3.36.0 )
	tracker? (
		>=app-misc/tracker-3.1.0
		>=app-misc/tracker-miners-3.1.0
		>=media-gfx/gnome-photos-${PV}
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
BDEPEND=""
S=${WORKDIR}
