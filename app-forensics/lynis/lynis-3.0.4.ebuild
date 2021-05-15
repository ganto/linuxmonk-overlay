# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit bash-completion-r1 systemd

DESCRIPTION="Security and system auditing tool"
HOMEPAGE="https://cisofy.com/lynis/"
SRC_URI="https://cisofy.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

S="${WORKDIR}/${PN}"

src_install() {
	doman lynis.8
	dodoc FAQ README
	newdoc CHANGELOG.md CHANGELOG

	dobashcomp extras/bash_completion.d/lynis

	# stricter default perms - bug 507436
	diropts -m0700
	insopts -m0600

	insinto /usr/share/${PN}
	doins -r db/ include/ plugins/

	dosbin lynis

	insinto /etc/${PN}
	doins default.prf
	sed -i -e 's/\/path\/to\///' "${S}/extras/systemd/${PN}.service" || die "Sed Failed!"
	systemd_dounit "${S}/extras/systemd/${PN}.service" || die "Sed Failed!"
	systemd_dounit "${S}/extras/systemd/${PN}.timer"
}
