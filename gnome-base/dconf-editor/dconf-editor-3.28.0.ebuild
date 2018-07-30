# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
VALA_MIN_API_VERSION="0.36"

inherit gnome2 meson vala

DESCRIPTION="Graphical tool for editing the dconf configuration database"
HOMEPAGE="https://git.gnome.org/browse/dconf-editor"

LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~arm-linux ~x86-linux"

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
