# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Convenient diffing in Ruby"
HOMEPAGE="https://github.com/samg/diffy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
