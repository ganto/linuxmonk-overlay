# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="XML library for PHP that you may not hate"
HOMEPAGE="http://sabre.io/xml/"
SRC_URI="https://github.com/sabre-io/xml/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-lang/php:*[xml,xmlreader,xmlwriter]
	dev-php/fedora-autoloader
	<dev-php/sabre-uri-3.0.0"
DEPEND="
	test? (
		${RDEPEND}
		dev-php/phpunit )"

S="${WORKDIR}/xml-${PV}"

src_prepare() {
	default
	if use test; then
		cp "${FILESDIR}"/autoload-test.php "${S}"/lib/autoload-test.php || die
	fi
}

src_install() {
	insinto "/usr/share/php/Sabre/Xml"
	doins -r lib/. "${FILESDIR}"/autoload.php
	dodoc README.md
}

src_test() {
	phpunit --bootstrap "${S}"/lib/autoload-test.php tests/ || die "test suite failed"
}
