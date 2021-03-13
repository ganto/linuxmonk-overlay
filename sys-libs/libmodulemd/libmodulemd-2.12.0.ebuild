# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit meson python-r1

DESCRIPTION="Module metadata manipulation library"
HOMEPAGE="https://github.com/fedora-modularity/libmodulemd"
SRC_URI="https://github.com/fedora-modularity/${PN}/releases/download/${P}/modulemd-${PV}.tar.xz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE="introspection"

RDEPEND="
	app-arch/rpm:=
	dev-libs/glib
	dev-libs/libyaml
	sys-apps/file

	${PYTHON_DEPS}
	>=dev-python/pygobject-3[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]

	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	sys-apps/help2man
	virtual/pkgconfig
"

S="${WORKDIR}"/modulemd-${PV}

src_prepare() {
	default

	sed -i 's|/usr/bin/sh|/bin/sh|g' modulemd/clang_simple_version.sh || die
}

libmodulemd_src_install_internal() {
	meson_src_install
	python_optimize
}

src_configure() {
	local emesonargs=(
		-Dpython_name=${EPYTHON}
		-Dwith_docs=false
		-Dwith_manpages=enabled
		-Dwith_py2=false
		$(meson_use !introspection skip_introspection)
	)
	python_foreach_impl meson_src_configure
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_install() {
	python_foreach_impl libmodulemd_src_install_internal

	# Rename for slotted installation
	mv "${D}"/usr/lib64/libmodulemd.so "${D}"/usr/lib64/libmodulemd-2.0.so
	sed -i 's/-lmodulemd/-lmodulemd-2.0/' "${D}"/usr/lib64/pkgconfig/modulemd-2.0.pc
}
