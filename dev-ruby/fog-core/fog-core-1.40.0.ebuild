# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby21"

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
	=dev-ruby/excon-0.49*
	=dev-ruby/formatador-0.2*
"

all_ruby_prepare() {
	# Remove Bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
}
