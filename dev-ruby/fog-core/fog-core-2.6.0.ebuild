# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md CONTRIBUTORS.md README.md changelog.md"

RUBY_FAKEGEM_GEMSPEC="fog-core.gemspec"

inherit ruby-fakegem

DESCRIPTION="fog's core behaviors without API and cloud provider specifics"
HOMEPAGE="https://github.com/fog/fog-core"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_bdepend "
	test? ( dev-ruby/minitest
			dev-ruby/minitest-stub-const )
"

ruby_add_rdepend "
	dev-ruby/builder:*
	dev-ruby/excon:1
	>=dev-ruby/formatador-0.2
	<dev-ruby/formatador-2.0
	dev-ruby/mime-types:*
"

all_ruby_prepare() {
	# Remove Bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
}
