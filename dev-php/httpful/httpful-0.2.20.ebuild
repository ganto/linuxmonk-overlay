# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A Chainable, REST Friendly, PHP HTTP Client"
HOMEPAGE="http://phphttpclient.com/"
SRC_URI="https://github.com/nategood/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*[curl]
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

src_install() {
	insinto "/usr/share/php/Httpful"
	doins -r src/Httpful/. "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit -c ./tests/phpunit.xml || die "test suite failed"
}
