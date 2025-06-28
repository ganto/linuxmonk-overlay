# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )

inherit meson python-r1

DESCRIPTION="C Library for manipulating Fedora Modularity metadata files"
HOMEPAGE="https://github.com/fedora-modularity/libmodulemd"
SRC_URI="https://github.com/fedora-modularity/libmodulemd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="gtk-doc +introspection +python test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	introspection? ( python )
	python? ( introspection ${PYTHON_REQUIRED_USE} )
"

DEPEND="
	app-arch/rpm:=
	dev-libs/glib:2
	dev-libs/libyaml
	sys-apps/file

	introspection? (
		dev-libs/gobject-introspection
		dev-python/pygobject:3[${PYTHON_USEDEP}]
	)
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
	gtk-doc? (
		dev-libs/glib[gtk-doc(+)]
		dev-util/gtk-doc
	)
	test? (
		sys-libs/libmodulemd
	)
"

src_configure() {
	local emesonargs=(
		-Dwith_manpages=enabled
		$(meson_use gtk-doc with_docs)
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

src_test() {
	if use python; then
		python_foreach_impl meson_src_test --no-suite ci_valgrind
	else
		meson_src_test --no-suite ci_valgrind
	fi
}

libmodulemd_src_install_internal() {
	meson_src_install
	# We need to compile the gobject introspection overrides to prevent QA warnings
	local PYTHON_GI_OVERRIDESDIR=$("${EPYTHON}" -c 'import gi;print(gi._overridesdir)' || die)
	python_optimize "${D}${PYTHON_GI_OVERRIDESDIR}/"
}

src_install() {
	if use python; then
		python_foreach_impl libmodulemd_src_install_internal
	else
		meson_src_install
	fi
}
