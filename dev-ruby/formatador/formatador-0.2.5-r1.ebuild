# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST="tests"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="changelog.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="STDOUT text formatting"
HOMEPAGE="https://github.com/geemus/formatador"

SRC_URI="https://github.com/geemus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/shindo )"
