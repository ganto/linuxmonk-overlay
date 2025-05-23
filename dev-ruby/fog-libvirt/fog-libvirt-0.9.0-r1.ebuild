# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="libvirt provider for fog"
HOMEPAGE="https://github.com/fog/fog-libvirt"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_bdepend "
	test? ( dev-ruby/minitest
			>=dev-ruby/mocha-1.13.0:1.0
			>=dev-ruby/shindo-0.3.4 )
"

ruby_add_rdepend "
	>=dev-ruby/fog-core-1.27.4
	dev-ruby/fog-json
	>=dev-ruby/fog-xml-0.1.1
	dev-ruby/json:*
	>=dev-ruby/ruby-libvirt-0.7.0
"

PATCHES=( "${FILESDIR}"/0.11.0-Fix-compatibility-with-Minitest-5.patch )

all_ruby_prepare() {
	# Remove Bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' -e 's/bundle exec //' Rakefile || die
}

each_ruby_test() {
	${RUBY} -Ilib -Iminitests -e "Dir.glob './minitests/**/*_test.rb', &method(:require)"
}
