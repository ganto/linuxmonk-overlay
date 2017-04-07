# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

inherit bash-completion-r1 ruby-fakegem

DESCRIPTION="Manage complex tmux sessions easily"
HOMEPAGE="https://github.com/tmuxinator/tmuxinator"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="test"

ruby_add_rdepend "
	>=dev-ruby/erubis-2.6
	>=dev-ruby/thor-0.15
"

all_ruby_install() {
	all_fakegem_install

	dosym tmuxinator /usr/bin/mux
	newbashcomp "completion/tmuxinator.bash" "tmuxinator"
}
