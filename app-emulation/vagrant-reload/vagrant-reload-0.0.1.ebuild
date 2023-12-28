# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A plugin that allows you to reload a Vagrant plugin as a provisioning step"
HOMEPAGE="https://github.com/aidanns/vagrant-reload"
SRC_URI="https://github.com/aidanns/vagrant-reload/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend "
	dev-ruby/rubygems
	>=app-emulation/vagrant-2.3.7
"

all_ruby_prepare() {
	# remove bundler support
	sed -i '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die
}

pkg_postinst() {
	# register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).add_plugin "vagrant-hostmanager";'
}

pkg_prerm() {
	# un-register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).remove_plugin "vagrant-hostmanager";'
}
