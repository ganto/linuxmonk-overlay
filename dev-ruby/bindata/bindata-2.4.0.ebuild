# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="BinData is a declarative way to read and write binary file formats"
HOMEPAGE="http://github.com/dmendel/bindata"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "
	test? ( dev-ruby/minitest:5 )
"

all_ruby_prepare() {
	# Remove Bundler                                                                                                                                                                                                                         
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Remove (unpackaged) Coveralls dependency
	sed -i -e '/[Cc]overalls/d' test/test_helper.rb || die
}
