# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Shared JSON related functionality for fog"
HOMEPAGE="https://github.com/fog/fog-json"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

ruby_add_rdepend "
	=dev-ruby/fog-core-1*
	>=dev-ruby/multi_json-1.10
"

all_ruby_prepare() {
	# Remove Bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Handle minitest ourselves to avoid bundler dependency.
	sed -i -e '1igem "minitest", "~> 5.0"' test/*_test.rb || die

	# loosen dependencies                                                                                                                                               
	sed -e '/multi_json/s/~>/>=/' -i ${PN}.gemspec || die
}
