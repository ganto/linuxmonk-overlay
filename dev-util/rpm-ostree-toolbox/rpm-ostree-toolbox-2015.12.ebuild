# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1

DESCRIPTION="App for automatically running rpm-ostree, generating disk images"
HOMEPAGE="https://github.com/projectatomic/rpm-ostree-toolbox"
SRC_URI="https://github.com/projectatomic/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="
	>=dev-libs/glib-2.40.0[${PYTHON_USEDEP}]
	>=dev-libs/gobject-introspection-1.34.0
	>=dev-libs/json-glib-1.0
	dev-libs/libgsystem
	dev-libs/libxslt
	>=dev-util/ostree-2014.4
	dev-util/rpm-ostree"

RDEPEND="${PYTHON_DEPS}
	app-arch/rpm
	app-emulation/imagefactory[${PYTHON_USEDEP}]
	dev-python/iniparse[${PYTHON_USEDEP}]
	dev-python/libvirt-python[${PYTHON_USEDEP}]"

DEPEND="${CDEPEND}
	test? ( dev-python/pylint[${PYTHON_USEDEP}] )
	virtual/pkgconfig"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	eautoreconf
	python_fix_shebang .
}

src_install() {
	default
	prune_libtool_files
}
