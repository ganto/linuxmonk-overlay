# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org meson

MY_PV="${PV/_/.}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A set of backgrounds packaged with the GNOME desktop"
HOMEPAGE="https://git.gnome.org/browse/gnome-backgrounds"
SRC_URI="mirror://gnome/sources/gnome-backgrounds/${MY_PV%%.*}/${PN}-${MY_PV}.tar.xz"

LICENSE="CC-BY-SA-2.0 CC-BY-SA-3.0 CC-BY-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND=">=sys-devel/gettext-0.19.8"

S="${WORKDIR}/${MY_P}"
