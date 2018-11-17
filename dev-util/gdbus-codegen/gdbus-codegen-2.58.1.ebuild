# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME_ORG_MODULE="glib"
PYTHON_COMPAT=( python{3_7,3_5,3_6,3_7} )
PYTHON_REQ_USE="xml"
DISTUTILS_SINGLE_IMPL=1

inherit gnome.org distutils-r1

DESCRIPTION="GDBus code and documentation generator"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-libs/libxslt
"
RDEPEND="${PYTHON_DEPS}
	!<dev-libs/glib-2.7.2-r1:2
"

# To prevent circular dependencies with glib[test]
PDEPEND=">=dev-libs/glib-${PV}:2"

S="${WORKDIR}/glib-${PV}/gio/gdbus-2.0/codegen"

python_prepare_all() {
	PATCHES=(
		"${FILESDIR}/${PN}-2.56.1-sitedir.patch"
	)
	distutils-r1_python_prepare_all

	sed -e 's:@PYTHON@:python:' gdbus-codegen.in > gdbus-codegen || die
	sed -e "s:@VERSION@:${PV}:g" config.py.in > config.py || die
	cp "${FILESDIR}/setup.py-2.32.4" setup.py || die "cp failed"
	sed -e "s/@PV@/${PV}/" -i setup.py || die "sed setup.py failed"
}

src_compile() {
	default

	# generate man page
	pushd ../../../docs/reference/gio
	xsltproc --nonet \
		--stringparam man.output.quietly 1 \
		--stringparam funcsynopsis.style ansi \
		--stringparam man.th.extra1.suppress 1 \
		--stringparam man.authors.section.enabled 0 \
		--stringparam man.copyright.section.enabled 0 \
		http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl \
		gdbus-codegen.xml
	popd
}

src_test() {
	einfo "Skipping tests. This package is tested by dev-libs/glib"
	einfo "when merged with FEATURES=test"
}

python_install_all() {
	distutils-r1_python_install_all # no-op, but prevents QA warning
	doman "${WORKDIR}/glib-${PV}/docs/reference/gio/gdbus-codegen.1"
}
