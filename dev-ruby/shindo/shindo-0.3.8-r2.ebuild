# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST=""             # → build_error test will/must always fail, wtf?!
RUBY_FAKEGEM_TASK_TEST="shindo_tests"   # only works if shindo is already installed
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.rdoc"

RUBY_FAKEGEM_BINWRAP="shindo shindont"

inherit ruby-fakegem

DESCRIPTION="Simple depth first Ruby testing"
HOMEPAGE="https://github.com/geemus/shindo"

SRC_URI="https://github.com/geemus/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

PATCHES=( "${FILESDIR}"/${PV}-ubygems-was-dropped-in-Ruby-2.5.patch )
