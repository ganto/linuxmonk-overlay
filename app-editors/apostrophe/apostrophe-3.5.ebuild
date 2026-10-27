# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PLOCALES="az bg ca cs da de el en_GB eo es eu fa fi fr fur gl he hi hr hu ia id ie is it ka kab kk kw my nb ne nl oc pl pt pt_BR ro ru si sk sl sr sv tr uk uz vi zh_CN zh_TW"
PYTHON_COMPAT=( python3_{12..14} )

inherit gnome2-utils meson optfeature plocale python-single-r1 xdg

DESCRIPTION="Distraction free Markdown editor for GNOME"
HOMEPAGE="https://apps.gnome.org/Apostrophe/ https://gitlab.gnome.org/World/apostrophe"
SRC_URI="https://gitlab.gnome.org/World/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/glib:2
	gui-libs/gtk:4[introspection]
	gui-libs/libadwaita:1[introspection]
"
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	app-text/libspelling
	gui-libs/gtksourceview:5[introspection]
	media-fonts/fira-mono
	media-fonts/fira-sans
	net-libs/webkit-gtk:6[introspection]
	|| (
		app-text/pandoc-bin[pandoc-symlink]
		app-text/pandoc-cli[lua]
	)
	$(python_gen_cond_dep '
		dev-python/chardet[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		dev-python/pypandoc[${PYTHON_USEDEP}]
		dev-python/regex[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/glib:2
	dev-libs/gobject-introspection
	sys-devel/gettext
	virtual/pkgconfig
	test? (
		dev-libs/appstream
		dev-util/desktop-file-utils
	)
"

src_prepare() {
	default

	# --math-method requires pandoc >=3.11, use the older equivalent option
	sed -i 's/--math-method=mathjax/--mathjax/' \
		apostrophe/{export_dialog,preview_converter}.py || die

	plocale_find_changes po '' '.po'
	rm_po() {
		rm po/${1}.po || die
		sed -i "/^${1}$/d" po/LINGUAS || die
	}
	plocale_for_each_disabled_locale rm_po
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/${PN}
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	optfeature "PDF export with LaTeX engines" dev-texlive/texlive-latexextra
	elog "PDF export uses Typst by default, which is available as app-text/typst"
	elog "from the GURU overlay."
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
