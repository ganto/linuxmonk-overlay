# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools gnome2

LIBGLNX_TAG=e72bbdebb03f5d39c7f32869299ca4284786344c

DESCRIPTION="GIO-based library with Unix/Linux specific API"
HOMEPAGE="https://github.com/GNOME/libgsystem"
SRC_URI="https://github.com/GNOME/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://git.gnome.org/browse/libglnx/snapshot/libglnx-${LIBGLNX_TAG}.tar.xz -> libglnx-${LIBGLNX_TAG:0:7}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

CDEPEND=">=dev-libs/glib-2.34.0
	>=dev-libs/gobject-introspection-1.34.0
	dev-libs/libxslt
	sys-apps/attr
	>=sys-devel/libtool-2.2.4
	sys-libs/libcap
	systemd? ( >=sys-apps/systemd-200 )"

DEPEND="${CDEPEND}
	>=dev-util/gtk-doc-1.15"

RDEPEND="${CDEPEND}"

src_prepare() {
	rmdir libglnx
	ln -s ../libglnx-${LIBGLNX_TAG} libglnx
	eautoreconf
}

src_configure() {
	local myconf
	test use systemd || myconf="${myconf} --without-systemd-journal"
	gnome2_src_configure ${myconf}
}
