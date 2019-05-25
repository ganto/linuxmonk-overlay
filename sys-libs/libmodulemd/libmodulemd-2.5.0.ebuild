# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Module metadata manipulation library"
HOMEPAGE="https://github.com/fedora-modularity/libmodulemd"
SRC_URI="https://github.com/fedora-modularity/${PN}/releases/download/${P}/modulemd-${PV}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

CDEPEND="
	dev-libs/glib
	dev-libs/libyaml
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	dev-libs/gobject-introspection
	dev-util/gtk-doc
"
BDEPEND=""

S="${WORKDIR}"/modulemd-${PV}

src_configure() {
	local emesonargs=(
		-Ddeveloper_build=false
		-Dbuild_api_v1=true
		-Dbuild_api_v2=true
	)
	meson_src_configure
}
