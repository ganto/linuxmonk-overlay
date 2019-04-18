# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot systemd

EGO_PN="github.com/prometheus/node_exporter"
EGIT_COMMIT="v${PV/_rc/-rc.}"
NODE_EXPORTER_COMMIT="f6f6194"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus exporter for machine metrics"
HOMEPAGE="https://github.com/prometheus/node_exporter"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-lang/go-1.11
	dev-util/promu
	sys-apps/moreutils
"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	pushd src/${EGO_PN} || die
	eapply "${FILESDIR}"/${PV}-smartmon.sh-add-metric-for-active-low-power-mode.patch
	sed -i -e "s/{{.Revision}}/${NODE_EXPORTER_COMMIT}/" .promu.yml || die
	popd || die
	default
}

src_compile() {
	pushd src/${EGO_PN} || die
	mkdir -p bin || die
	GO111MODULE=on GOPATH="${S}" GOCACHE="${T}"/go-cache promu build -v --prefix node_exporter || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin node_exporter/node_exporter
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	systemd_dounit "${FILESDIR}"/node_exporter.service
	systemd_dounit "${FILESDIR}"/node_exporter-smartmon.service
	systemd_dounit "${FILESDIR}"/node_exporter-smartmon.timer
	insinto /etc/sysconfig
	newins examples/systemd/sysconfig.node_exporter node_exporter
	exeinto /usr/share/node_exporter
	doexe text_collector_examples/*
	insinto /usr/share/node_exporter
	doins text_collector_examples/README.md
	popd || die
	keepdir /var/lib/node_exporter/textfile_collector
	fowners -R ${PN}:${PN} /var/lib/node_exporter
}
