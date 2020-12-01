# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake fcaps systemd

FTL_GIT_VERSION="v${PV}"
# Retrieved via:
#   git checkout v${PV}
#   git --no-pager show --date=short --format=\"%ai\" --name-only | head -n 1
FTL_GIT_DATE="2020-11-28 21:59:12 +0100"
#   git --no-pager describe --always --dirty
FTL_GIT_HASH="e1db31d"

DESCRIPTION="The Pi-hole FTL engine"
HOMEPAGE="https://pi-hole.net/"
SRC_URI="https://github.com/pi-hole/FTL/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://ftl.pi-hole.net/macvendor.db"

LICENSE="EUPL-1.2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="readline"

RDEPEND="
	acct-user/pihole
	acct-group/pihole
"
DEPEND="${RDEPEND}
	dev-libs/gmp[pic,static-libs]
	>=dev-libs/nettle-3.6[static-libs]
	net-dns/libidn[static-libs]
	readline? ( sys-libs/readline[static-libs] )
"
BDEPEND=""

S="${WORKDIR}/${P#pihole-}"

PATCHES=(
	"${FILESDIR}/${PV}-logs-from-var-log-var-log-pihole.patch"
	"${FILESDIR}/${PV}-Disable-blocking-if-not-explicitly-defined-in-setupVars-conf.patch"
)

FILECAPS=( cap_net_raw,cap_net_bind_service,cap_net_admin,cap_sys_nice+eip usr/bin/pihole-FTL )

src_prepare() {
	cmake_src_prepare

	# don't set file capabilities through cmake
	sed -e '/SETCAP/d' -i src/CMakeLists.txt || die
}

cmake_build() {
	_cmake_check_build_dir
	pushd "${BUILD_DIR}" > /dev/null || die

	export GIT_VERSION=${FTL_GIT_VERSION} \
		GIT_DATE=${FTL_GIT_DATE} \
		GIT_BRANCH=master \
		GIT_TAG=${FTL_GIT_VERSION} \
		GIT_HASH=${FTL_GIT_HASH}
	cmake --build .

	popd > /dev/null || die
}

src_install() {
	cmake_src_install

	insinto /etc/pihole
	doins "${DISTDIR}"/macvendor.db

	insopts -m0664
	doins "${FILESDIR}/${PN}.conf"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" "${PN}"

	doman "${FILESDIR}/${PN}.8"
	doman "${FILESDIR}/${PN}.conf.5"

	diropts -m0750
	keepdir /var/log/pihole

	fowners pihole:pihole /etc/pihole /var/log/pihole
	fowners pihole /etc/pihole/${PN}.conf

	newinitd "${FILESDIR}"/${PN}.initd "${PN}"
	systemd_dounit "${FILESDIR}/${PN}.service"
}
