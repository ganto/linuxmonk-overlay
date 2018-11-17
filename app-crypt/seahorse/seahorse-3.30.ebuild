# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome.org meson vala

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="https://wiki.gnome.org/Apps/Seahorse"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
IUSE="ldap zeroconf"
KEYWORDS="~amd64"

COMMON_DEPEND="
	>=app-crypt/gcr-3.11.91:=
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.22.0:3
	>=app-crypt/libsecret-0.16
	>=net-libs/libsoup-2.33.92:2.4
	x11-misc/shared-mime-info

	net-misc/openssh
	>=app-crypt/gpgme-1.7.0
	>=app-crypt/gnupg-2.0.12

	ldap? ( net-nds/openldap:= )
	zeroconf? ( >=net-dns/avahi-0.6:= )
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.35
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"
# Need seahorse-plugins git snapshot
RDEPEND="${COMMON_DEPEND}
	!<app-crypt/seahorse-plugins-2.91.0_pre20110114
"

src_prepare() {
	default
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dpgp-support=true
		-Dpkcs11-support=true
		-Dkeyservers-support=true
		$(meson_use ldap ldap-support)
		$(meson_use zeroconf key-sharing)
	)

	meson_src_configure
}
