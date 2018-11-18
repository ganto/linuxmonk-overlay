# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils bash-completion-r1 systemd

DESCRIPTION="Security and system auditing tool"
HOMEPAGE="https://cisofy.com/lynis/"
SRC_URI="https://cisofy.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="app-shells/bash"

S="${WORKDIR}/${PN}"

src_prepare() {
	default

	# Fix script path
	sed -i 's|/path/to/lynis|/usr/sbin/lynis|' extras/systemd/lynis.service
}

src_install() {
	doman lynis.8
	dodoc CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md CONTRIBUTORS.md FAQ README

	dobashcomp extras/bash_completion.d/lynis

	systemd_dounit extras/systemd/lynis.service
	systemd_dounit extras/systemd/lynis.timer

	# stricter default perms - bug 507436
	diropts -m0700
	insopts -m0600

	insinto /usr/share/${PN}
	doins -r db/ include/ plugins/

	dosbin lynis

	insinto /etc/${PN}
	doins default.prf
}