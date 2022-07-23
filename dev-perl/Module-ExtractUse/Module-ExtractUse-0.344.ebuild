# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DOMM
inherit perl-module

DESCRIPTION="Find out what modules are used"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Parse-RecDescent-1.967.9
	dev-perl/Pod-Strip
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
BDEPEND="dev-perl/Module-Build"

SRC_TEST="do"
