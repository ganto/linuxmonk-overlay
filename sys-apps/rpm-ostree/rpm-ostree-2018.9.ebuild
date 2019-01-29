# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LIBGLNX_TAG=470af8763ff7b99bec950a6ae0a957c1dcfc8edd
LIBDNF_TAG=7ecb2f5ddc93ae6f819b95ef7940b1d4dd66eb4d

CRATES="
bitflags-1.0.4
cc-1.0.25
cfg-if-0.1.6
cloudabi-0.0.3
cstr-argument-0.0.2
curl-0.4.14
curl-sys-0.4.14
c_utf8-0.1.0
dtoa-0.4.2
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
gio-sys-0.6.0
glib-0.5.0
glib-sys-0.6.0
gobject-sys-0.6.0
itoa-0.4.3
kernel32-sys-0.2.2
lazy_static-1.2.0
libc-0.2.43
libsystemd-sys-0.2.2
libz-sys-1.0.25
linked-hash-map-0.5.1
log-0.4.6
memchr-1.0.2
openat-0.1.15
openssl-probe-0.1.2
openssl-sys-0.9.39
pkg-config-0.3.14
proc-macro2-0.4.24
quote-0.6.10
rand-0.5.5
rand_core-0.2.2
rand_core-0.3.0
redox_syscall-0.1.43
remove_dir_all-0.5.1
schannel-0.1.14
semver-parser-0.7.0
serde-1.0.78
serde_derive-1.0.80
serde_json-1.0.20
serde_yaml-0.7.5
socket2-0.3.8
syn-0.15.22
systemd-0.4.0
tempfile-3.0.3
unicode-xid-0.1.0
utf8-cstr-0.1.6
vcpkg-0.2.6
version_check-0.1.5
winapi-0.2.7
winapi-0.3.6
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
yaml-rust-0.4.2
"

inherit autotools cargo

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
IUSE="doc"

COMMON_DEPEND="
	app-arch/libarchive:=
	>=app-arch/rpm-4.13.0.1:=
	dev-libs/expat:=
	>=dev-libs/glib-2.50.0:=
	>=dev-libs/gobject-introspection-1.34.0:=
	>=dev-libs/json-glib-1.0:=
	>=dev-libs/libsolv-0.6.21:=
	dev-libs/libxslt:=
	>=dev-util/ostree-2018.9:=
	sys-apps/attr:=
	sys-apps/systemd:=
	sys-auth/polkit:=
	sys-libs/libcap:=
	sys-libs/librepo:=
"
DEPEND="${COMMON_DEPEND}
	dev-libs/check
	dev-util/cmake
	dev-util/gperf
	>=dev-util/gtk-doc-1.15
	gnome-base/gnome-common
	virtual/cargo
	virtual/pkgconfig
	virtual/rust
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/bubblewrap
	sys-fs/fuse:*
"

DOCS=( docs/CONTRIBUTING.md HACKING.md README.md )

PATCHES=(
	"${FILESDIR}"/${P}-rust-Drop-crates-io-patch-and-use-0.4.0.patch
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
		$(use_enable doc gtk-doc-html)
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	emake || die "Failed to compile"
}

src_install() {
	emake install DESTDIR=${D}
}
