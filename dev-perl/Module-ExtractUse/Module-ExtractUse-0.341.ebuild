# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DOMM
inherit perl-module

DESCRIPTION="Find out what modules are used"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Parse-RecDescent-1.967.9
	>=dev-perl/Pod-Strip-1.00
	virtual/perl-Pod-Escapes
	virtual/perl-Pod-Simple
"
DEPEND="
	${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
		>=dev-perl/Test-Deep-0.087
		dev-perl/Test-NoWarnings
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
		dev-perl/UNIVERSAL-require
	)
"

SRC_TEST="do"
