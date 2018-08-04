# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the applications of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+share +shotwell +tracker"

KEYWORDS="~amd64 ~x86"

# Note to developers:
# This is a wrapper for the extra apps integrated with GNOME 3
# Keep pkg order within a USE flag as upstream releng versions file
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}

	>=sys-apps/baobab-3.28.0
	>=media-video/cheese-3.28.0
	>=www-client/epiphany-3.28.1.1
	>=app-arch/file-roller-3.28.1
	>=gnome-extra/gnome-calculator-${PV}
	>=gnome-extra/gnome-calendar-${PV}
	>=gnome-extra/gnome-characters-${PV}
	>=gnome-extra/gnome-contacts-${PV}
	>=sys-apps/gnome-disk-utility-${PV}
	>=media-gfx/gnome-font-viewer-3.28.0
	>=media-gfx/gnome-screenshot-3.26.0
	>=gnome-extra/gnome-system-monitor-${PV}
	>=gnome-extra/gnome-weather-3.26.0
	>=gnome-extra/gnome-maps-${PV}
	>=gnome-extra/sushi-3.28.3
	>=net-misc/vino-3.22.0

	>=gnome-base/dconf-editor-3.28.0
	>=mail-client/evolution-${PV}
	>=gnome-extra/gnome-tweaks-3.28.1

	share? ( >=gnome-extra/gnome-user-share-3.28.0 )
	shotwell? ( >=media-gfx/shotwell-0.24 )
	tracker? (
		>=app-misc/tracker-2.1.0
		>=gnome-extra/gnome-documents-3.28.1
		>=media-gfx/gnome-photos-${PV}
		>=media-sound/gnome-music-${PV} )
"
DEPEND=""
S=${WORKDIR}
