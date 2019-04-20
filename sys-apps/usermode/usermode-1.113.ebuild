# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Tools for certain user account management tasks"
HOMEPAGE="https://pagure.io/usermode/"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="selinux +suid"

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
	sys-apps/util-linux
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	sys-apps/shadow
"

DOCS=( AUTHORS ChangeLog NEWS README )

PATCHES=( "${FILESDIR}"/${PN}-1.112-Add-sys-sysmacros-include.patch )

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

	if use suid; then
		chmod 4711 "${D}"/usr/sbin/userhelper
	fi

	# make userformat symlink to usermount
	dosym usermount /usr/bin/userformat
	dosym usermount.1.bz2 /usr/share/man/man1/userformat.1.bz2

	insinto /etc/security/console.apps
	doins "${FILESDIR}"/config-util
}
