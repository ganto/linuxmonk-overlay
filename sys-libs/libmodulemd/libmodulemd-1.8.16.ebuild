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
IUSE="introspection test"

RDEPEND="
	dev-libs/glib
	dev-libs/libyaml
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/modulemd-${PV}

src_configure() {
	local emesonargs=(
		-Ddeveloper_build=false
		-Dwith_docs=false
		$(meson_use !introspection skip_introspection)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	# Remove generic library symlink to allow slotted installation
	rm "${D}"/usr/lib64/libmodulemd.so
}
