# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1

PIHOLE_GIT_VERSION="v${PV}"
PIHOLE_GIT_HASH="6b536b74"

DESCRIPTION="DNS sinkhole service"
HOMEPAGE="https://pi-hole.net"
SRC_URI="https://github.com/pi-hole/pi-hole/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="EUPL-1.2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ipv6"

DEPEND="
	acct-user/pihole
	acct-group/pihole
"
RDEPEND="${DEPEND}
	dev-db/sqlite
	>=net-dns/pihole-FTL-5.2
	net-misc/curl[ssl]
	net-misc/iputils[ipv6?]
	sys-process/lsof
"
BDEPEND=""

DOCS=( CONTRIBUTING.md README.md )

PATCHES=(
	"${FILESDIR}/${PV}-gravity-sh-Dont-depend-on-git-repository-checkout.patch"
	"${FILESDIR}/${PV}-pihole-Set-usr-bin-script-path.patch"
	"${FILESDIR}/${PV}-pihole-Disable-reconfigure-update-checkout-uninstall.patch"
	"${FILESDIR}/${PV}-Use-private-log-directory.patch"
	"${FILESDIR}/${PV}-version-sh-Read-local-version-from-file-if-no-GITDIR.patch"
	"${FILESDIR}/${PV}-version-sh-Dont-show-error-on-missing-setupVars-conf.patch"
)

src_prepare() {
	default

	# Remove LCD setup script (only works on RasberryPi)
	rm advanced/Scripts/setupLCD.sh
}

src_compile() { :; }

src_install() {
	dobin pihole

	# Install Pi-hole helper scripts
	exeinto /opt/pihole
	for script in gravity.sh advanced/Scripts/*.sh advanced/Scripts/COL_TABLE; do
		doexe "${script}"
	done

	# Install blocklist database scripts
	exeinto /opt/pihole/database_migration
	doexe advanced/Scripts/database_migration/gravity-db.sh
	insinto /opt/pihole/database_migration
	doins advanced/Templates/*.sql

	# Install the configs
	# TODO: Only required for Web interface
	#insinto /etc/pihole
	#doins "${FILESDIR}"/dns-servers.conf

	# Write current version
	dodir /etc/pihole
	echo "${PIHOLE_GIT_VERSION} ${PIHOLE_GIT_HASH}" > "${D}"/etc/pihole/VERSION

	# Custom configuration for pihole-FTL
	insinto /etc/dnsmasq.d
	doins advanced/01-pihole.conf

	insinto /etc/cron.d
	newins "${FILESDIR}"/pihole.cron pihole

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/pihole.logrotate pihole

	dobashcomp advanced/bash-completion/pihole

	doman manpages/pihole.8
	dodoc "${DOCS[@]}"
}
