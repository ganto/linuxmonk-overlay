# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A few useful extensions to core Ruby classes."
HOMEPAGE="https://github.com/bbatsov/powerpack"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
