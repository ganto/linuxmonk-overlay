# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC=""

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md CONTRIBUTORS.md README.md"

inherit ruby-fakegem

DESCRIPTION="Shared XML related functionality for fog"
HOMEPAGE="https://github.com/fog/fog-xml"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

ruby_add_bdepend "
	test? ( =dev-ruby/minitest-4*:0 )
"

ruby_add_rdepend "
	dev-ruby/fog-core
	>=dev-ruby/nokogiri-1.5.11
"

all_ruby_prepare() {
	# Remove Bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Handle minitest ourselves to avoid bundler dependency
	sed -i -e '1igem "minitest", "< 5.0"' spec/minitest_helper.rb || die

	# We don't have Turn in Gentoo (neither we really need it).
	sed -i '/require.*turn/ s/^/#/' spec/minitest_helper.rb
	sed -i '/Turn/,/end/ s/^/#/' spec/minitest_helper.rb
}
