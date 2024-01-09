# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_TASK_DOC="none"

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
	>=dev-ruby/thor-1.3.0
	>=dev-ruby/xdg-2.2.3
"

all_ruby_install() {
	all_fakegem_install

	dosym tmuxinator /usr/bin/mux

	newbashcomp completion/tmuxinator.bash tmuxinator
	dosym tmuxinator "$(get_bashcompdir)"/mux
	dosym tmuxinator.fish /usr/share/fish/completions/mux.fish

	insinto /usr/share/zsh/site-functions
	newins completion/tmuxinator.zsh _mux
}
