# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit eutils virtualx python-r1 meson

SRC_URI="https://download.gnome.org/sources/pygobject/3.30/pygobject-${PV}.tar.xz"

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="https://wiki.gnome.org/Projects/PyGObject"

LICENSE="LGPL-2.1+"
SLOT="3"
KEYWORDS="~amd64"
IUSE="examples +cairo"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

COMMON_DEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.38.0:2
	>=dev-libs/gobject-introspection-1.46.0:=
	virtual/libffi:=
	>=dev-python/pycairo-1.11.1[${PYTHON_USEDEP}]
	x11-libs/cairo
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	x11-libs/cairo[glib]
	dev-libs/atk[introspection]
	x11-libs/cairo[glib]
	>=x11-libs/gdk-pixbuf-2.38.0:2[introspection]
	>=x11-libs/gtk+-3.24.0:3[introspection]
	x11-libs/pango[introspection]
"

RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13
	!<dev-python/pygobject-2.28.6-r50:2[introspection]
"
