# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="none"         # → build_error test will/must always fail, wtf?!
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_BINWRAP="shindo shindont"

inherit ruby-fakegem

DESCRIPTION="Simple depth first Ruby testing"
HOMEPAGE="https://github.com/geemus/shindo"

SRC_URI="https://github.com/geemus/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
