# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_TASK_DOC="none"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Stub constants for the duration of a block in MiniTest"
HOMEPAGE="https://github.com/adammck/minitest-stub-const"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

each_ruby_test() {
	${RUBY} -Ilib test/*.rb || die "tests failed"
}
