# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Analyzes and Reports on system logs"
HOMEPAGE="http://www.logwatch.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}/${P%%_*}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/cron
	virtual/mta
	virtual/mailx
	dev-lang/perl
	dev-perl/Date-Calc
	dev-perl/Date-Manip
	dev-perl/Tie-IxHash
	dev-perl/Sys-CPU
	dev-perl/Sys-MemInfo"

PATCHES=(
	"${FILESDIR}"/${PN}-7.4.2-openssh-hpn.patch
	"${FILESDIR}"/${PN}-7.4.3-postfix.patch
)

S="${WORKDIR}/${P%%_*}"

src_install() {
	dodir /usr/share/logwatch/lib
	dodir /usr/share/logwatch/scripts/services
	dodir /usr/share/logwatch/scripts/shared
	dodir /usr/share/logwatch/default.conf/logfiles
	dodir /usr/share/logwatch/default.conf/services
	dodir /usr/share/logwatch/default.conf/html
	keepdir /etc/logwatch

	newsbin scripts/logwatch.pl logwatch.pl

	exeinto /usr/share/logwatch/lib
	doexe lib/*.pm

	exeinto /usr/share/logwatch/scripts/services
	doexe scripts/services/*

	exeinto /usr/share/logwatch/scripts/shared
	doexe scripts/shared/*

	insinto /usr/share/logwatch/default.conf
	doins conf/logwatch.conf

	insinto /usr/share/logwatch/default.conf/logfiles
	doins conf/logfiles/*

	insinto /usr/share/logwatch/default.conf/services
	doins conf/services/*

	insinto /usr/share/logwatch/default.conf/html
	doins conf/html/*

	# Make sure logwatch is run before anything else #100243
	exeinto /etc/cron.daily
	newexe "${FILESDIR}"/logwatch 00-logwatch

	doman logwatch.8
	dodoc README HOWTO-Customize-LogWatch

	# Do last due to insopts modification.
	insinto /usr/share/logwatch/scripts/logfiles
	insopts -m755
	doins -r scripts/logfiles/*
}

pkg_postinst() {
	if [[ -e ${ROOT}/etc/cron.daily/logwatch ]] ; then
		local md5=$(md5sum "${ROOT}"/etc/cron.daily/logwatch)
		[[ ${md5} == "edb003cbc0686ed4cf37db16025635f3" ]] \
			&& rm -f "${ROOT}"/etc/cron.daily/logwatch \
			|| ewarn "You have two logwatch files in /etc/cron.daily/"
	fi
}
