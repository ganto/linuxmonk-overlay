# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils versionator

MY_PV=$( replace_all_version_separators _ ${PV} )
MY_P=${PN}_${MY_PV}

DESCRIPTION="Simple package library built on top of hawkey and librepo"
HOMEPAGE="https://github.com/rpm-software-management/libhif"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${MY_P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

CDEPEND=">=app-arch/rpm-4.11.0
	>=dev-libs/glib-2.36.0
	dev-libs/gobject-introspection
	dev-libs/libxslt
	>=sys-libs/hawkey-0.4.6
	>=sys-libs/librepo-1.7.11"

DEPEND="${CDEPEND}
	>=dev-util/gtk-doc-1.9
	virtual/pkgconfig"

RDEPEND="${CDEPEND}"

S="${WORKDIR}/libhif-${MY_P}"

src_prepare() {
	eapply_user

	eautoreconf
}

src_configure() {
	econf \
		--disable-dnf-yumdb \
		--disable-static \
		--enable-gtk-doc \
		$(use_enable doc gtk-doc-html)
}

src_install() {
	default
	prune_libtool_files
}
