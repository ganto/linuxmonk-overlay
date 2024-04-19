# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC="none"
RUBY_FAKEGEM_EXTRADOC="DEMO.md HISTORY.md README.md"

inherit ruby-fakegem

DESCRIPTION="Module for supporting the XDG Base Directory Standard"
HOMEPAGE="https://www.alchemists.io/projects/xdg/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

each_ruby_test() {
	${RUBY} -Ilib:. -v test/*.rb || die "tests failed"
}
