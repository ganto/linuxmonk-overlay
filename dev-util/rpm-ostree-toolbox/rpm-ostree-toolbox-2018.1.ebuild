# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit autotools python-single-r1 eutils user

DESCRIPTION="App for automatically running rpm-ostree, generating disk images"
HOMEPAGE="https://github.com/projectatomic/rpm-ostree-toolbox"
SRC_URI="https://github.com/projectatomic/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.40.0:=
	>=dev-libs/gobject-introspection-1.34.0:=
	>=dev-libs/json-glib-1.0:=
	dev-libs/libgsystem:=
	dev-libs/libxslt:=
	>=dev-util/ostree-2014.4:=
"
RDEPEND="${COMMON_DEPEND}
	app-emulation/docker
	app-emulation/libguestfs[${PYTHON_USEDEP}]
	>=dev-util/imagefactory-1.1.6[python_targets_python2_7]
	${PYTHON_DEPS}
	dev-python/iniparse[${PYTHON_USEDEP}]
	dev-python/libvirt-python[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-util/rpm-ostree
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-1.15
	gnome-base/gnome-common
	virtual/pkgconfig
"

pkg_setup() {
	python-single-r1_pkg_setup

	enewgroup rpmostreecompose
	enewuser rpmostreecompose -1 /sbin/nologin /usr/lib/lib/rpm-ostree-toolbox rpmostreecompose
}

src_prepare() {
	default
	eautoreconf
	python_fix_shebang .
}

src_install() {
	default
	prune_libtool_files

	fowners rpmostreecompose:rpmostreecompose /var/lib/lib/rpm-ostree-toolbox
	keepdir /var/lib/lib/rpm-ostree-toolbox
}
