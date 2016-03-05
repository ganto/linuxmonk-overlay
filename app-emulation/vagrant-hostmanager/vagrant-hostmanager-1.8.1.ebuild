# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST=""
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Vagrant plugin that manages the /etc/hosts file on guest machines"
HOMEPAGE="https://github.com/smdahlen/vagrant-hostmanager"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).add_plugin "vagrant-hostmanagers";'
}

pkg_prerm() {
	# un-register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).remove_plugin "vagrant-hostmanager";'
}
