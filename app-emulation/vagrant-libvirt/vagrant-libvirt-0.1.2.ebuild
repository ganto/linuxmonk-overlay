# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26"

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

PATCHES=(
	# Enable QEMU Session by default
	# https://github.com/vagrant-libvirt/vagrant-libvirt/pull/969
	"${FILESDIR}"/0.0.45-enable-qemu-session-by-default.patch

	# Halt a domain before packaging it as a box to avoid hard to debug issues.
	# https://github.com/vagrant-libvirt/vagrant-libvirt/pull/1034.
	"${FILESDIR}"/0003-Halt-a-domain-before-packaging-it-as-a-box.patch
)

ruby_add_rdepend "
	>=app-emulation/vagrant-1.9.1
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
