# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 meson

DESCRIPTION="A set of backgrounds packaged with the GNOME desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-backgrounds"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="!<x11-themes/gnome-themes-standard-3.14"
DEPEND="
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
"
