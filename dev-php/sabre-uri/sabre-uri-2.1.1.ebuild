# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Functions for making sense out of URIs in PHP"
HOMEPAGE="http://sabre.io/uri/"
SRC_URI="https://github.com/sabre-io/uri/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*
	dev-php/fedora-autoloader"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

S="${WORKDIR}/uri-${PV}"

src_prepare() {
	default
	cp "${FILESDIR}"/autoload.php "${S}"/lib || die
}

src_install() {
	insinto "/usr/share/php/Sabre/Uri"
	doins -r lib/.
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/lib/autoload.php tests/ || die "test suite failed"
}
