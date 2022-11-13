# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit meson python-r1

DESCRIPTION="Module metadata manipulation library"
HOMEPAGE="https://github.com/fedora-modularity/libmodulemd"
SRC_URI="https://github.com/fedora-modularity/${PN}/releases/download/${PV}/modulemd-${PV}.tar.xz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE="+introspection +python"

REQUIRED_USE="
	introspection? ( python )
	python? ( introspection ${PYTHON_REQUIRED_USE} )
"

DEPEND="
	app-arch/rpm:=
	dev-libs/glib
	dev-libs/libyaml
	sys-apps/file

	introspection? (
		dev-libs/gobject-introspection
		>=dev-python/pygobject-3[${PYTHON_USEDEP}]
	)
	python? (
		${PYTHON_DEPS}
		dev-python/six[${PYTHON_USEDEP}]
	)"
RDEPEND="${DEPEND}"
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
		-Dwith_docs=false
		-Dwith_manpages=enabled
		$(meson_use python with_py3)
		$(meson_use !introspection skip_introspection)
	)
	if use python; then
		python_foreach_impl meson_src_configure
	else
		meson_src_configure
	fi
}

src_compile() {
	if use python; then
		python_foreach_impl meson_src_compile
	else
		meson_src_compile
	fi
}

src_install() {
	if use python; then
		python_foreach_impl libmodulemd_src_install_internal
	else
		meson_src_install
	fi

	# Rename for slotted installation
	mv "${D}"/usr/lib64/libmodulemd.so "${D}"/usr/lib64/libmodulemd-2.0.so
	sed -i 's/-lmodulemd/-lmodulemd-2.0/' "${D}"/usr/lib64/pkgconfig/modulemd-2.0.pc
}
