# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Tools for certain user account management tasks"
HOMEPAGE="https://fedorahosted.org/usermode/"
SRC_URI="https://fedorahosted.org/releases/u/s/usermode/usermode-1.111.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="selinux"

CDEPEND="
	dev-libs/glib:2
	dev-perl/XML-Parser
	selinux? ( sys-libs/libselinux )
	sys-libs/libuser
	>=x11-libs/gtk+-2.23:2
	x11-libs/startup-notification
	virtual/pam
"
DEPEND="${CDEPEND}
	dev-util/desktop-file-utils
	dev-util/intltool
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	sys-apps/shadow
	sys-apps/util-linux
"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	default_src_prepare

	eautoreconf

	for i in userinfo.desktop.in userpasswd.desktop.in usermount.desktop.in; do
		echo -e '\nNotShowIn=GNOME;KDE;' >> "${i}"
	done
}

src_configure() {
	econf $(use_with selinux)
}

src_install() {
	default_src_install

	dosym usermount /usr/bin/userformat
	dosym usermount.1.bz2 /usr/share/man/man1/userformat.1.bz2

	insinto /etc/security/console.apps
	doins "${FILESDIR}"/config-util
}
