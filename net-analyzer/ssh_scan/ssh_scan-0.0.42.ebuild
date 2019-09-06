# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="config data"

inherit ruby-fakegem

SSH_BADKEYS_COMMIT=c7e6506e29fb167c9036f5a7dd5721bbe993b7ec

DESCRIPTION="A prototype SSH configuration and policy scanner"
HOMEPAGE="https://mozilla.github.io/ssh_scan/"
SRC_URI="https://github.com/mozilla/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/rapid7/ssh-badkeys/archive/${SSH_BADKEYS_COMMIT}.zip -> ssh-badkeys-${SSH_BADKEYS_COMMIT:0:7}.zip"

LICENSE="Ruby MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	dev-ruby/bindata:*
	dev-ruby/netaddr
	dev-ruby/net-ssh:*
	dev-ruby/sshkey
"

all_ruby_prepare() {
	# Remove Bundler
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die

	# Remove (unpackaged) Coveralls dependency
	sed -i -e '/[Cc]overalls/d' spec/spec_helper.rb || die

	# Don't install license and readme of ssh-badkeys
	rm -f "${WORKDIR}"/all/ssh-badkeys-${SSH_BADKEYS_COMMIT}/{README.md,LICENSE}
}

each_ruby_install() {
	each_fakegem_install

	# install ssh-badkeys
	insinto "$(ruby_fakegem_gemsdir)/gems/${P}/data/ssh-badkeys"
	doins -r "${WORKDIR}"/all/ssh-badkeys-${SSH_BADKEYS_COMMIT}/.
}
