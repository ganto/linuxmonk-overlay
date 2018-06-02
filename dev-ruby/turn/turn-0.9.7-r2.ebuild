# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24"

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
	dev-ruby/ansi
	=dev-ruby/minitest-4*
"

each_ruby_test() {
	${RUBY} "-Ilib bin/turn -Ilib -v test/*.rb" || die "tests failed"
}
