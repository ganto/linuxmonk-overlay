# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

LIBGLNX_TAG=7e24c244ffb3c1b7825c9e45dbf2806b86e46f95
BSDIFF_TAG=1edf9f656850c0c64dae260960fabd8249ea9c60

DESCRIPTION="Git for operating system binaries"
HOMEPAGE="https://wiki.gnome.org/Projects/OSTree"
SRC_URI="https://git.gnome.org/browse/ostree/snapshot/${P}.tar.xz
	https://git.gnome.org/browse/libglnx/snapshot/libglnx-${LIBGLNX_TAG}.tar.xz -> libglnx-${LIBGLNX_TAG:0:7}.tar.xz
	https://github.com/mendsley/bsdiff/archive/${BSDIFF_TAG}.zip -> bsdiff-${BSDIFF_TAG:0:7}.zip"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc dracut grub selinux"

CDEPEND=">=app-arch/libarchive-2.8.0
	app-arch/lzma
	>=app-crypt/gpgme-1.1.8
	dev-libs/gjs
	>=dev-libs/glib-2.40.0:2
	>=dev-libs/gobject-introspection-1.34.0
	>=dev-libs/libgsystem-2015.1
	dev-libs/libxslt
	>=net-libs/libsoup-2.39.1:2.4
	selinux? ( >=sys-libs/libselinux-2.1.13 )
	sys-libs/zlib"

DEPEND="${CDEPEND}
	>=dev-util/gtk-doc-1.15"

RDEPEND="${CDEPEND}
	dracut? ( sys-kernel/dracut )
	grub? ( sys-boot/grub:2 )"

src_prepare() {
	rmdir libglnx &&
	ln -s ../libglnx-${LIBGLNX_TAG} libglnx &&
	rmdir bsdiff &&
	ln -s ../bsdiff-${BSDIFF_TAG} bsdiff || die "source linking failed"

	# Workaround automake bug with subdir-objects and computed paths
	sed -e 's,$(libglnx_srcpath),'${S}/libglnx,g < libglnx/Makefile-libglnx.am >libglnx/Makefile-libglnx.am.inc
	sed -e 's,$(libbsdiff_srcpath),'${S}/bsdiff,g < bsdiff/Makefile-bsdiff.am >bsdiff/Makefile-bsdiff.am.inc

	eautoreconf || die "autoreconf failed"
}

src_configure() {
	econf \
		--enable-gtk-doc \
		$(use_enable doc gtk-doc-html) \
		$(use_with dracut) \
		$(use_with grub grub2) \
		--with-libarchive \
		$(use_with selinux) \
		--with-soup
}
