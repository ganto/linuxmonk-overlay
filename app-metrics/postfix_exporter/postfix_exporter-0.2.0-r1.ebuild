# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_VENDOR=(
	"github.com/alecthomas/kingpin e7f8ee3d9b4b47000af44d34904a9e4f598e577f"
	"github.com/alecthomas/template a0175ee3bccc567396460bf5acd36800cb10c49c"
	"github.com/alecthomas/units 2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
	"github.com/beorn7/perks 3a771d992973f24aa725d07868b467d1ddfceafb"
	"github.com/coreos/go-systemd 93d5ec2c7f76e57b4f3cb9fa4ee4e3ea43f3e5c9"
	"github.com/coreos/pkg 399ea9e2e55f791b6e3d920860dbecb99c3692f0"
	"github.com/golang/protobuf c823c79ea1570fb5ff454033735a8e68575d1d0f"
	"github.com/hpcloud/tail a1dbeea552b7c8df4b542c66073e393de198a800"
	"github.com/matttproud/golang_protobuf_extensions c182affec369e30f25d3eb8cd8a478dee585ae7d"
	"github.com/prometheus/client_golang 4c99dd66303a54cbf8559dd6110d5c30b1819e4c"
	"github.com/prometheus/client_model fd36f4220a901265f90734c3183c5f0c91daa0b8"
	"github.com/prometheus/common f866ba39776a736ba5d34760f5fae4ad74e63f2e"
	"github.com/prometheus/procfs 18fdf56864f4dd3613607e581db94175f2d59f93"
)
inherit golang-build golang-vcs-snapshot
EGO_PN="github.com/kumina/postfix_exporter"

DESCRIPTION="Prometheus Exporter for Postfix"
HOMEPAGE="https://github.com/kumina/postfix_exporter"

SRC_URI="https://github.com/kumina/postfix_exporter/archive/${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="Apache-2.0 BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

COMMON_DEPEND="acct-group/postfix_exporter
acct-user/postfix_exporter"
DEPEND="systemd? ( sys-apps/systemd )
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

RESTRICT+=" test"

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" \
		go build -tags "$(usex systemd '' 'nosystemd')" -v -o bin/${PN} || die
	popd || die
}

src_install() {
	dobin src/${EGO_PN}/bin/${PN}
	dodoc src/${EGO_PN}/{CHANGELOG,README}.md
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
}
