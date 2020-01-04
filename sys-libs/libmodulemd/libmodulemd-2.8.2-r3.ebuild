# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit meson python-r1

DESCRIPTION="Module metadata manipulation library"
HOMEPAGE="https://github.com/fedora-modularity/libmodulemd"
SRC_URI="https://github.com/fedora-modularity/${PN}/releases/download/${P}/modulemd-${PV}.tar.xz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64"
IUSE="introspection"

RDEPEND="
	app-arch/rpm
	dev-libs/glib
	dev-libs/libyaml
	sys-apps/file

	${PYTHON_DEPS}
	>=dev-python/pygobject-3[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]

	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="${RDEPEND}
	!!sys-libs/libmodulemd:2
"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/modulemd-${PV}

src_prepare() {
	default

	sed -i 's|/usr/bin/sh|/bin/sh|g' modulemd/clang_simple_version.sh || die
}

libmodulemd_src_configure_internal() {
	local emesonargs=(
		-Ddeveloper_build=false
		-Dskip_formatters=true
		-Dskip_clang_tidy=true
		-Dwith_docs=false
	)
	if ! python_is_python3; then
		emesonargs+=(
			-Dpython_name=${EPYTHON}
			-Dskip_introspection=true
			-Dwith_py2_overrides=true
		)
	fi
	if python_is_python3; then
		emesonargs+=(
			-Dpython_name=${EPYTHON}
			$(meson_use !introspection skip_introspection)
			-Dwith_py2_overrides=false
			-Dwith_py3_overrides=true
		)
	fi
	meson_src_configure
}

libmodulemd_src_compile_internal() {
	# Meson still needs python3 available when building for python2.7
	# Avoid error:
	#   python_wrapper_setup: python3 is not supported by python2.7 (PYTHON_COMPAT)
	if ! python_is_python3; then
		rm "${T}"/${EPYTHON}/bin/python3 || die
		ln -s /usr/bin/python3 "${T}"/${EPYTHON}/bin/python3 || die
	fi
	meson_src_compile
}

libmodulemd_src_install_internal() {
	meson_src_install
	if ! python_is_python3; then
		python_fix_shebang --force "${D}"$(python_get_sitedir)
	fi
	python_optimize
}

src_configure() {
	python_foreach_impl libmodulemd_src_configure_internal
}

src_compile() {
	python_foreach_impl libmodulemd_src_compile_internal
}

src_install() {
	python_foreach_impl libmodulemd_src_install_internal

	# Rename for slotted installation
	mv "${D}"/usr/lib64/libmodulemd.so "${D}"/usr/lib64/libmodulemd-2.0.so
	sed -i 's/-lmodulemd/-lmodulemd-2.0/' "${D}"/usr/lib64/pkgconfig/modulemd-2.0.pc
}
