# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md CONTRIBUTORS.md README.md changelog.md"

RUBY_FAKEGEM_GEMSPEC="fog-core.gemspec"

inherit ruby-fakegem

DESCRIPTION="fog's core behaviors without API and cloud provider specifics"
HOMEPAGE="https://github.com/fog/fog-core"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "
	test? ( dev-ruby/minitest
			dev-ruby/minitest-stub-const )
"

ruby_add_rdepend "
	dev-ruby/builder:*
	>=dev-ruby/excon-0.71
	>=dev-ruby/formatador-0.2
	dev-ruby/mime-types:*
"

PATCHES=( "${FILESDIR}"/2.2.4-fix-cache-test-for-ruby-3.1.patch )

all_ruby_prepare() {
	# Remove Bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
}
