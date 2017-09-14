# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST=none
RUBY_FAKEGEM_RECIPE_DOC=none

inherit ruby-fakegem

DESCRIPTION="A package for manipulating network addresses"
HOMEPAGE="https://rubygems.org/gems/netaddr"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DOCS=( changelog README )

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib:. --pattern='.*_test\.rb' test/
}
