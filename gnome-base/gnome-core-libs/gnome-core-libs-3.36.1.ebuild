# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the core libraries of GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="cups python"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64"

# Note to developers:
# This is a wrapper for the core libraries used by GNOME 3
RDEPEND="
	>=dev-libs/glib-2.64.1:2
	>=x11-libs/gdk-pixbuf-2.40.0:2
	>=x11-libs/pango-1.44.7
	>=x11-libs/gtk+-3.24.16:3[cups?]
	>=dev-libs/atk-2.34.1
	>=gnome-base/librsvg-2.48.2
	>=gnome-base/gnome-desktop-3.36.1:3
	>=x11-libs/startup-notification-0.12

	>=gnome-base/gvfs-1.44.1
	>=gnome-base/dconf-0.36.0

	>=media-libs/gstreamer-1.14.5:1.0
	>=media-libs/gst-plugins-base-1.14.5:1.0
	>=media-libs/gst-plugins-good-1.14.5:1.0

	python? ( >=dev-python/pygobject-3.36.0:3 )
"
DEPEND=""
BDEPEND=""

S="${WORKDIR}"