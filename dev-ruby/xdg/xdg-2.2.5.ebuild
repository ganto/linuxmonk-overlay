# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_DOC="none"
RUBY_FAKEGEM_EXTRADOC="DEMO.md HISTORY.md README.md"

inherit ruby-fakegem

DESCRIPTION="Module for supporting the XDG Base Directory Standard"
HOMEPAGE="http://rubyworks.github.com/xdg"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

each_ruby_test() {
	${RUBY} -Ilib:. -v test/*.rb || die "tests failed"
}
