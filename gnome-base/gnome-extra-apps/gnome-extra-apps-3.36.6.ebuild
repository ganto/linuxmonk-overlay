# Copyright 1999-2020 Gentoo Authors
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

	>=sys-apps/baobab-3.34.1
	>=media-video/cheese-3.34.0
	>=www-client/epiphany-3.36.4
	>=app-arch/file-roller-3.36.3
	>=gnome-extra/gnome-calculator-3.36.0
	>=gnome-extra/gnome-calendar-3.36.2
	>=gnome-extra/gnome-characters-3.34.0
	>=gnome-extra/gnome-clocks-3.36.2
	>=gnome-extra/gnome-contacts-3.36.2
	>=sys-apps/gnome-disk-utility-3.36.3
	>=media-gfx/gnome-font-viewer-3.34.0
	>=media-gfx/gnome-screenshot-3.36.0
	>=gnome-extra/gnome-system-monitor-3.36.1
	>=gnome-extra/gnome-weather-3.36.1
	>=gnome-extra/gucharmap-12.0.1:2.90
	>=sci-geosciences/gnome-maps-3.36.4
	>=gnome-extra/sushi-3.34.0
	>=media-sound/sound-juicer-3.24.0

	>=gnome-base/dconf-editor-3.36.2
	>=app-dicts/gnome-dictionary-3.26.1
	>=mail-client/evolution-3.36.5
	>=gnome-extra/gnome-tweaks-3.34.0
	>=gnome-extra/nautilus-sendto-3.8.6
	>=net-misc/vinagre-3.22.0

	share? ( >=gnome-extra/gnome-user-share-3.34.0 )
	shotwell? ( >=media-gfx/shotwell-0.30.10 )
	systemd? ( >=gnome-extra/gnome-logs-3.36.0 )
	tracker? (
		>=app-misc/tracker-2.3.6
		>=app-misc/tracker-miners-2.3.5
		>=media-gfx/gnome-photos-3.34.2
		>=media-sound/gnome-music-3.36.5 )
"
DEPEND=""
BDEPEND=""
S=${WORKDIR}
