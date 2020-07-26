# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST=none
RUBY_FAKEGEM_RECIPE_DOC=none

inherit ruby-fakegem

DESCRIPTION="A package for manipulating network addresses"
HOMEPAGE="https://rubygems.org/gems/netaddr"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

DOCS=( changelog README )

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib:. --pattern='.*_test\.rb' test/
}
