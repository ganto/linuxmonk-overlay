# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Stub constants for the duration of a block in MiniTest"
HOMEPAGE="https://github.com/adammck/minitest-stub-const"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"

each_ruby_test() {
	${RUBY} -Ilib test/*.rb || die "tests failed"
}
