# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRAINSTALL="locales templates"
RUBY_FAKEGEM_EXTRADOC="BOXES.md CHANGELOG.md CONTRIBUTING.md README.md"

inherit ruby-fakegem

DESCRIPTION="LXC provider for Vagrant"
HOMEPAGE="https://github.com/fgrehm/vagrant-lxc"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="app-emulation/lxc"

ruby_add_rdepend ">=app-emulation/vagrant-1.8.0"

all_ruby_prepare() {
	# remove bundler support
	sed -i '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die
}

each_ruby_install() {
	each_fakegem_install

	# install helper scripts which must be executable
	exeinto $(ruby_fakegem_gemsdir)/gems/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}/scripts
	doexe scripts/*
}

pkg_postinst() {
	# register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).add_plugin "vagrant-lxc";'
}

pkg_prerm() {
	# un-register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).remove_plugin "vagrant-lxc";'
}
