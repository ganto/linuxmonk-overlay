# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Core execution tool for unprivileged containers"
HOMEPAGE="https://github.com/projectatomic/bubblewrap"
SRC_URI="https://github.com/projectatomic/bubblewrap/releases/download/v${PV}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="selinux"

DEPEND="
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt:=
	sys-libs/libcap:=
	selinux? ( sys-libs/libselinux )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable selinux)
}
