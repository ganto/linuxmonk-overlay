# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27"

# Depends on unreleased vagrant-spec gem
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRAINSTALL="locales"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="libvirt provider for Vagrant"
HOMEPAGE="https://github.com/vagrant-libvirt/vagrant-libvirt"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=app-emulation/vagrant-2.2.7
	>=dev-ruby/fog-core-2.1
	>=dev-ruby/fog-libvirt-0.6.0
	>=dev-ruby/nokogiri-1.6.0
"

each_ruby_install() {
	each_fakegem_install

	# loosen dependencies
	sed -e '/fog-core/s/~>/>=/' \
		-e '/nokogiri/s/~>/>=/' \
		-i "${ED}"$(ruby_fakegem_gemsdir)/specifications/${P}.gemspec || die
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
