# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33"

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

ruby_add_rdepend "
	>=app-emulation/vagrant-2.2.7
	dev-ruby/diffy
	>=dev-ruby/fog-core-2.1
	>=dev-ruby/fog-libvirt-0.6.0
	>=dev-ruby/nokogiri-1.6.0
	dev-ruby/rexml
	dev-ruby/xml-simple
"

PATCHES=(
	"${FILESDIR}"/vagrant-libvirt-0.12.2-Fix-REXML-3-4-2-compatibility.patch
	"${FILESDIR}"/vagrant-libvirt-0.12.2-Remove-config-unsupported-by-fog-libvirt.patch
	"${FILESDIR}"/vagrant-libvirt-0.12.2-Replace-CGI.parse-with-URI-equivalent.patch
)

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
