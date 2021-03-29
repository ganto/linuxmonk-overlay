# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2 meson

DESCRIPTION="Collection of tools for building and converting documentation"
HOMEPAGE="https://wiki.gnome.org/Apps/Yelp/Tools"

LICENSE="|| ( GPL-2+ freedist ) GPL-2+" # yelp.m4 is GPL2 || freely distributable
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.8
	dev-util/itstool
	>=gnome-extra/yelp-xsl-3.38.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"
