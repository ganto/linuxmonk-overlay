# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Convenient diffing in Ruby"
HOMEPAGE="https://github.com/samg/diffy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
