# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31"

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
	test? ( dev-ruby/minitest:5 )
"

ruby_add_rdepend "
	dev-ruby/fog-core
	>=dev-ruby/nokogiri-1.5.11
"

all_ruby_prepare() {
	# Remove Bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# We don't have Turn in Gentoo (neither we really need it).
	sed -i '/require.*turn/ s/^/#/' spec/minitest_helper.rb
	sed -i '/Turn/,/end/ s/^/#/' spec/minitest_helper.rb
}
