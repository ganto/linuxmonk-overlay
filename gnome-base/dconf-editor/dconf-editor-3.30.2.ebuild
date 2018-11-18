# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.40"
# override because VALA_MAX_API_VERSION from eclass is < VALA_MIN_API_VERSION
VALA_MAX_API_VERSION="0.40"

inherit gnome2 meson vala

DESCRIPTION="Graphical tool for editing the dconf configuration database"
HOMEPAGE="https://git.gnome.org/browse/dconf-editor"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~amd64"

COMMON_DEPEND="
	dev-libs/appstream-glib
	>=dev-libs/glib-2.55.1:2
	>=gnome-base/dconf-0.26.1
	>=x11-libs/gtk+-3.22.27:3
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-base/dconf-0.22[X]
"

src_prepare() {
	default
	vala_src_prepare
}
