# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Collection of GPG keys used in Linux distributions"
HOMEPAGE="https://github.com/xsuchy/distribution-gpg-keys"
SRC_URI="https://github.com/xsuchy/${PN}/archive/${P}-1.tar.gz"
RESTRICT="mirror"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="copr"

DOCS=( README.md SOURCES.md )

S="${WORKDIR}/distribution-gpg-keys-${P}-1"

src_install() {
	default

	insinto /usr/share/${PN}
	if use copr ; then
		doins -r keys/*
	else
		doins -r keys/{adobe,alma,amazon-linux,anolis,anydesk,bacula,bluejeans,brave,calcforge,centos,circle,datto,dell,dropbox,elastic,epel,eurolinux,fedora,google-cloud,google,intel,ius,jenkins,jpackage,mageia,mariadb,microsoft,mysql,navy,openeuler,openmandriva,opensuse,oraclelinux,postgresql,qubes,redhat,remi,rocky,rosa,rpmfusion,scientific-linux,skype,smeserver,suse,teamviewer,unitedrpms,virtualbox,zimbra,zoom}
	fi
}
