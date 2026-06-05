# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="changelog.txt README.md"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_TASK_TEST="none"

inherit ruby-fakegem

DESCRIPTION="STDOUT text formatting"
HOMEPAGE="https://github.com/geemus/formatador"

SRC_URI="https://github.com/geemus/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "dev-ruby/reline"
ruby_add_bdepend "test? ( dev-ruby/shindo )"

each_ruby_test() {
	RUBYOPT=-Ilib shindo
}
