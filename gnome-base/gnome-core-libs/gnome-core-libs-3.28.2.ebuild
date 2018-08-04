# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the core libraries of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="cups python"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME 3
RDEPEND="
	>=dev-libs/glib-2.56.1:2
	>=x11-libs/gdk-pixbuf-2.36.12:2
	>=x11-libs/pango-1.42.1
	>=x11-libs/gtk+-3.22.30:3[cups?]
	>=dev-libs/atk-2.28.1
	>=gnome-base/librsvg-2.42.2
	>=gnome-base/gnome-desktop-${PV}:3
	>=x11-libs/startup-notification-0.12

	>=gnome-base/gvfs-1.36.2
	>=gnome-base/dconf-0.28

	>=media-libs/gstreamer-1.14.0:1.0
	>=media-libs/gst-plugins-base-1.14.0:1.0
	>=media-libs/gst-plugins-good-1.14.0:1.0

	python? ( >=dev-python/pygobject-3.28.2:3 )
"
DEPEND=""

S="${WORKDIR}"
