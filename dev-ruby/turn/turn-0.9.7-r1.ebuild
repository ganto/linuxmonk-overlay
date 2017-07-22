# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="History.txt README.md NOTICE.md"

inherit ruby-fakegem

DESCRIPTION="Provides a set of alternative runners for MiniTest"
HOMEPAGE="https://rubygems.org/gems/turn"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/ansi-1.1
	=dev-ruby/minitest-4*
"

each_ruby_test() {
	${RUBY} bin/turn -v test/*.rb || die "tests failed"
}
