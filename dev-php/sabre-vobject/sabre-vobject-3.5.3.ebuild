# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Library to parse and manipulate iCalendar and vCard objects"
HOMEPAGE="http://sabre.io/vobject/"
SRC_URI="https://github.com/sabre-io/vobject/archive/${PV}.tar.gz -> ${P}.tar.gz"

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

PATCHES=(
	"${FILESDIR}"/php-sabre-vobject-bin.patch
	"${FILESDIR}"/"${P}"-Fix-timezone.patch
)

S="${WORKDIR}/vobject-${PV}"

src_prepare() {
	default
	cp "${FILESDIR}"/autoload.php "${S}"/lib/
	sed -e "s:@BUILDROOT@/usr/share/php/Sabre/VObject/:${S}/lib/:" -i tests/bootstrap.php
}

src_install() {
	dobin bin/generate_vcards bin/vobject
	insinto "/usr/share/php/Sabre/VObject"
	doins -r lib/.
	dodoc README.md
}

src_test() {
	cd tests
	phpunit || die "test suite failed"
}
