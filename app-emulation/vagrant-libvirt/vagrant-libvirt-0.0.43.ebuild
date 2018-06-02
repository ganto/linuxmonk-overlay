# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_RECIPE_DOC=""
# TODO: make tools scripts executable, move to better place
RUBY_FAKEGEM_EXTRAINSTALL="locales tools"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC=vagrant-libvirt.gemspec

inherit ruby-fakegem

DESCRIPTION="libvirt provider for Vagrant"
HOMEPAGE="https://github.com/pradels/vagrant-libvirt"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=app-emulation/vagrant-1.9.0
	=dev-ruby/fog-core-1.43.0*
	>=dev-ruby/fog-libvirt-0.3.0
	>=dev-ruby/nokogiri-1.6.0
"

all_ruby_prepare() {
	# remove bundler support
	sed -i '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die
}

all_ruby_install() {
	all_fakegem_install
	dodoc -r example_box
}

pkg_postinst() {
	# register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).add_plugin "vagrant-libvirt";'
}

pkg_prerm() {
	# un-register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).remove_plugin "vagrant-libvirt";'
}
