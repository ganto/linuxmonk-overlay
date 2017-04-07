# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST=""

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Automatic Ruby code style checking tool."
HOMEPAGE="http://github.com/bbatsov/rubocop"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/parser-2.3.0.4
	<dev-ruby/parser-3.0
	=dev-ruby/powerpack-0.1*
	dev-ruby/rainbow:2
	=dev-ruby/ruby-progressbar-1.7*
"

each_ruby_install() {
	each_fakegem_install
	ruby_fakegem_doins -r config
}
