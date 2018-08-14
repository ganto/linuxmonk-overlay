# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_DOC="none"
RUBY_FAKEGEM_EXTRADOC="DEMO.md HISTORY.md README.md"

inherit ruby-fakegem

DESCRIPTION="Module for supporting the XDG Base Directory Standard"
HOMEPAGE="http://rubyworks.github.com/xdg"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

each_ruby_test() {
	${RUBY} -Ilib:. -v test/*.rb || die "tests failed"
}
