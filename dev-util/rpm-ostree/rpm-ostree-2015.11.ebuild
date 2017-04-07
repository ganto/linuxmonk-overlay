# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

LIBGLNX_TAG=c7da81208df4053774cb4b38adff8863ca0838f5

DESCRIPTION="Store RPMs in OSTree repository"
HOMEPAGE="https://github.com/projectatomic/rpm-ostree"
SRC_URI="https://github.com/projectatomic/rpm-ostree/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://git.gnome.org/browse/libglnx/snapshot/libglnx-${LIBGLNX_TAG}.tar.xz -> libglnx-${LIBGLNX_TAG:0:7}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

CDEPEND="app-arch/rpm
	>=dev-libs/glib-2.40.0
	>=dev-libs/gobject-introspection-1.34.0
	>=dev-libs/json-glib-1.0
	>=dev-libs/libgsystem-2015.1
	dev-libs/libxslt
	>=dev-util/ostree-2015.11
	gnome-base/gnome-common
	sys-apps/attr
	sys-libs/hawkey
	sys-libs/libcap
	>=sys-libs/libhif-0.2.0"

DEPEND="${CDEPEND}
	>=dev-util/gtk-doc-1.15
	virtual/pkgconfig"

RDEPEND="${CDEPEND}"

DOCS=( README.md TODO )

src_prepare() {
	rmdir libglnx
	ln -s ../libglnx-${LIBGLNX_TAG} libglnx
	cp libglnx/Makefile-libglnx.am libglnx/Makefile-libglnx.am.inc
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		--enable-gtk-doc \
		$(use_enable doc gtk-doc-html)
}

src_install() {
	einstall
	prune_libtool_files
}
