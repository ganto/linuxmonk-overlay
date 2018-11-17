# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
GNOME_ORG_MODULE="glib"

inherit gnome.org python-single-r1

DESCRIPTION="Build utilities for GLib using projects"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2.1+"
SLOT="0" # /usr/bin utilities that can't be parallel installed by their nature
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="~amd64"

RDEPEND="${PYTHON_DEPS}
	!<dev-libs/glib-2.57.2-r1:2
"
DEPEND="${RDEPEND}"

src_configure() { :; }

src_compile() {
	sed -e "s:@VERSION@:${PV}:g;s:@PYTHON@:python:g" gobject/glib-genmarshal.in > gobject/glib-genmarshal
	sed -e "s:@VERSION@:${PV}:g;s:@PYTHON@:python:g" gobject/glib-mkenums.in > gobject/glib-mkenums

	make_manpage() {
		xsltproc --nonet \
			--stringparam man.output.quietly 1 \
			--stringparam funcsynopsis.style ansi \
			--stringparam man.th.extra1.suppress 1 \
			--stringparam man.authors.section.enabled 0 \
			--stringparam man.copyright.section.enabled 0 \
			http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl \
			"${1}"
	}

	# generate man page
	pushd docs/reference/gobject
	for manpage in glib-genmarshal glib-mkenums; do
		make_manpage ${manpage}.xml || die "Failed to generate man-page"
	done
	popd
	pushd docs/reference/glib
	make_manpage gtester-report.xml || die "Failed to generate man-page"
	popd
}

src_install() {
	python_fix_shebang gobject/glib-genmarshal
	python_fix_shebang gobject/glib-mkenums
	python_fix_shebang glib/gtester-report
	exeinto /usr/bin
	doexe gobject/glib-genmarshal
	doexe gobject/glib-mkenums
	doexe glib/gtester-report
	doman docs/reference/gobject/glib-genmarshal.1
	doman docs/reference/gobject/glib-mkenums.1
	doman docs/reference/glib/gtester-report.1
}
