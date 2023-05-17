# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby30 ruby31 ruby32"

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
IUSE=""

PATCHES="${FILESDIR}/${PV}-ruby32-File-exists-removal.patch"
