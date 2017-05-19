# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Vagrant provisioning plugin to generate Ansible inventory to use outside Vagrant"
HOMEPAGE="https://github.com/MatthewMi11er/vai"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=app-emulation/vagrant-1.8.0"

all_ruby_prepare() {
	# remove bundler support
	sed -i '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die
}

pkg_postinst() {
	# register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).add_plugin "vai";'
}

pkg_prerm() {
	# un-register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).remove_plugin "vai";'
}
