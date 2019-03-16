# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Compiler for the GObject type system"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

SRC_URI="https://download.gnome.org/sources/vala/0.44/vala-${PV}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0.44"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	>=dev-libs/glib-2.40:2
	>=dev-libs/vala-common-${PV}
"

#TODO: slot install is a bit broken
DEPEND="${RDEPEND}
	!${CATEGORY}/${PN}:0
	dev-libs/libxslt
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	test? (
		dev-libs/dbus-glib
		>=dev-libs/glib-2.26:2 )
	>=media-gfx/graphviz-2.40.1
	!dev-lang/vala:0.38
"

src_configure() {
	gnome2_src_configure --disable-unversioned
}
