# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

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
	>=dev-ruby/thor-0.15
	>=dev-ruby/xdg-2.2.3
"

PATCHES=(
	"${FILESDIR}"/${PV}-add-tmux-2.9-support.patch
)

all_ruby_install() {
	all_fakegem_install

	dosym tmuxinator /usr/bin/mux

	newbashcomp completion/tmuxinator.bash tmuxinator
	dosym tmuxinator "$(get_bashcompdir)"/mux

	insinto /usr/share/fish/completions
	doins completion/tmuxinator.fish
	dosym tmuxinator.fish /usr/share/fish/completions/mux.fish

	insinto /usr/share/zsh/site-functions
	newins completion/tmuxinator.zsh _mux
}
