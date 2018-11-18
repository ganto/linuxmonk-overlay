# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"

inherit meson bash-completion-r1 gnome2 systemd

DESCRIPTION="Virtual filesystem implementation for gio"
HOMEPAGE="https://wiki.gnome.org/Projects/gvfs"

LICENSE="LGPL-2+"
SLOT="0"

IUSE="afp archive bluray cdda elogind fuse google gnome-keyring gnome-online-accounts gphoto2 +http ios mtp nfs policykit samba systemd test +udev udisks zeroconf"
REQUIRED_USE="
	cdda? ( udev )
	elogind? ( !systemd udisks )
	google? ( gnome-online-accounts )
	mtp? ( udev )
	systemd? ( !elogind udisks )
	udisks? ( udev )
"
KEYWORDS="~amd64"

RDEPEND="
	app-crypt/gcr:=
	>=dev-libs/glib-2.57.2:2
	dev-libs/libxml2:2
	net-misc/openssh
	afp? ( >=dev-libs/libgcrypt-1.2.2:0= )
	archive? ( app-arch/libarchive:= )
	bluray? ( media-libs/libbluray:= )
	elogind? ( >=sys-auth/elogind-229:0= )
	fuse? ( >=sys-fs/fuse-2.8.0:0 )
	gnome-keyring? ( app-crypt/libsecret )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.17.1:= )
	google? (
		>=dev-libs/libgdata-0.17.9:=[crypt,gnome-online-accounts]
		>=net-libs/gnome-online-accounts-3.17.1:= )
	gphoto2? ( >=media-libs/libgphoto2-2.5.0:= )
	http? ( >=net-libs/libsoup-2.42:2.4 )
	ios? (
		>=app-pda/libimobiledevice-1.2:=
		>=app-pda/libplist-1:= )
	mtp? (
		>=dev-libs/libusb-1.0.21
		>=media-libs/libmtp-1.1.12 )
	nfs? ( >=net-fs/libnfs-1.9.8 )
	policykit? (
		>=sys-auth/polkit-0.114
		sys-libs/libcap )
	samba? ( >=net-fs/samba-4.5.10[client] )
	systemd? ( >=sys-apps/systemd-206:0= )
	udev? (
		cdda? ( dev-libs/libcdio-paranoia )
		>=virtual/libgudev-147:=
		virtual/libudev:= )
	udisks? ( >=sys-fs/udisks-1.97:2 )
	zeroconf? ( >=net-dns/avahi-0.6 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	>=sys-devel/gettext-0.19.4
	virtual/pkgconfig
	dev-util/gtk-doc-am
	test? (
		>=dev-python/twisted-16
		|| (
			net-analyzer/netcat
			net-analyzer/netcat6 ) )
	!udev? ( >=dev-libs/libgcrypt-1.2.2:0 )
"
# libgcrypt.m4, provided by libgcrypt, needed for eautoreconf, bug #399043
# test dependencies needed per https://bugzilla.gnome.org/700162

# Tests with multiple failures, this is being handled upstream at:
# https://bugzilla.gnome.org/700162
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-1.30.2-sysmacros.patch #580234
)

src_prepare() {
	if ! use udev; then
		sed -e 's/gvfsd-burn/ /' \
			-e 's/burn.mount.in/ /' \
			-e 's/burn.mount/ /' \
			-i daemon/Makefile.am || die
	fi

	gnome2_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dgdu=false
		-Dgcr=true
		-Dman=true
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		$(meson_use mtp)
		$(meson_use afp)
		$(meson_use archive)
		$(meson_use bluray)
		$(meson_use cdda)
		$(meson_use elogind logind)
		$(meson_use fuse)
		$(meson_use gnome-online-accounts goa)
		$(meson_use gnome-keyring keyring)
		$(meson_use google)
		$(meson_use gphoto2)
		$(meson_use http)
		$(meson_use ios afc)
		$(meson_use nfs)
		$(meson_use policykit admin)
		$(meson_use systemd logind)
		$(meson_use udev gudev)
		$(meson_use udisks udisks2)
		$(meson_use samba smb)
		$(meson_use zeroconf dnssd)
	)

	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_install() {
	meson_src_install
}