# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools cargo eutils

LIBGLNX_TAG=97b5c08d2f93dc93ba296a84bbd2a5ab9bd8fc97
LIBDNF_TAG=b3fcc53f6f3baf4f51f836f5e1eb54eb82d5df49

CRATES="
bitflags-1.0.3
dtoa-0.4.2
gio-sys-0.6.0
glib-0.5.0
glib-sys-0.6.0
gobject-sys-0.6.0
itoa-0.4.1
lazy_static-1.0.1
libc-0.2.42
linked-hash-map-0.5.1
pkg-config-0.3.11
proc-macro2-0.4.6
quote-0.6.3
serde-1.0.66
serde_derive-1.0.66
serde_json-1.0.20
serde_yaml-0.7.5
syn-0.14.2
unicode-xid-0.1.0
yaml-rust-0.4.0
"

DESCRIPTION="Hybrid image/package system"
HOMEPAGE="https://github.com/projectatomic/rpm-ostree"
SRC_URI="https://github.com/projectatomic/rpm-ostree/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://gitlab.gnome.org/GNOME/libglnx/-/archive/${LIBGLNX_TAG}/libglnx-${LIBGLNX_TAG}.tar.gz -> libglnx-${LIBGLNX_TAG:0:7}.tar.gz
	https://github.com/projectatomic/libdnf/archive/${LIBDNF_TAG}/libdnf-${LIBDNF_TAG:0:7}.tar.gz
	$(cargo_crate_uris ${CRATES})
"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc rust"

COMMON_DEPEND="
	app-arch/libarchive:=
	>=app-arch/rpm-4.13.0.1:=
	dev-libs/expat:=
	>=dev-libs/glib-2.50.0:=
	>=dev-libs/gobject-introspection-1.34.0:=
	>=dev-libs/json-glib-1.0:=
	>=dev-libs/libsolv-0.6.21:=
	dev-libs/libxslt:=
	>=dev-util/ostree-2018.2:=
	sys-apps/attr:=
	sys-apps/systemd:=
	sys-auth/polkit:=
	sys-libs/libcap:=
	sys-libs/librepo:=
"
DEPEND="${COMMON_DEPEND}
	rust? (
		dev-util/cargo
		virtual/rust
	)
	dev-libs/check
	dev-util/cmake
	dev-util/gperf
	>=dev-util/gtk-doc-1.15
	gnome-base/gnome-common
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	app-emulation/bubblewrap
	sys-fs/fuse:*
"

DOCS=( docs/CONTRIBUTING.md HACKING.md README.md )

PATCHES=(
	"${FILESDIR}"/${P}-build-sys-Link-with-ldl-for-rust-build.patch
)

src_prepare() {
	default

	# prepare embedded libglnx sources
	rmdir libglnx
	ln -s ../libglnx-${LIBGLNX_TAG} libglnx
	cp libglnx/Makefile-libglnx.am libglnx/Makefile-libglnx.am.inc

	# FIXME - figure out how to get aclocal to find this by default
	ln -sf ../libglnx/libglnx.m4 buildutil/libglnx.m4

	# prepare embedded libdnf sources
	rmdir libdnf
	ln -s ../libdnf-${LIBDNF_TAG} libdnf

	eautoreconf
}

src_configure() {
	econf \
		--disable-silent-rules \
		--enable-gtk-doc \
		$(use_enable doc gtk-doc-html) \
		$(use_enable rust)
}

src_compile() {
	if use rust; then
		export CARGO_HOME="${ECARGO_HOME}"
	fi

	emake || die "Failed to compile"
}

src_install() {
	default
	prune_libtool_files
}
