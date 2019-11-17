# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Module metadata manipulation library"
HOMEPAGE="https://github.com/fedora-modularity/libmodulemd"
SRC_URI="https://github.com/fedora-modularity/${PN}/releases/download/${P}/modulemd-${PV}.tar.xz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE="introspection gtk-doc"
REQUIRED_USE="gtk-doc? ( introspection )"
RESTRICT="test"

CDEPEND="
	dev-libs/glib[gtk-doc?]
	dev-libs/libyaml
"
RDEPEND="${CDEPEND}"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	introspection? ( dev-libs/gobject-introspection )
	gtk-doc? ( dev-util/gtk-doc )
"
BDEPEND=""

S="${WORKDIR}"/modulemd-${PV}

src_prepare() {
	default

	sed -i 's|/usr/bin/sh|/bin/sh|g' modulemd/clang_simple_version.sh || die
}

src_configure() {
	local emesonargs=(
		-Ddeveloper_build=false
		$(meson_use !introspection skip_introspection)
		-Dskip_formatters=true
		$(meson_use gtk-doc with_docs)
	)
	meson_src_configure
}
