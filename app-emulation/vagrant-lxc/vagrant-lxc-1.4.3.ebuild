# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25"

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

RDEPEND="app-admin/sudo"
# Required for generating the vagrant-lxc sudo wrapper
DEPEND="${RDEPEND}
	app-emulation/lxc
	net-misc/bridge-utils
	sys-apps/iproute2
	sys-apps/net-tools
	sys-apps/which
"

PATCHES=( "${FILESDIR}"/${PV}-Fix-sudo-wrapper-for-system-wide-plugin.patch )

ruby_add_rdepend ">=app-emulation/vagrant-1.9.1"

all_ruby_prepare() {
	# remove bundler support
	sed -i '/[Bb]undler/d' Rakefile || die
	rm Gemfile || die
}

src_install() {
	echo "Creating sudoers file"
	# create sudoers file for vagrant-lxc-wrapper
	dodir /etc/sudoers.d/
	echo "# Automatically created by vagrant-lxc" > ${ED}etc/sudoers.d/vagrant-lxc
	chmod 0440 "${ED}"etc/sudoers.d/vagrant-lxc

	ruby-ng_src_install
}

each_ruby_install() {
	each_fakegem_install

	# install helper scripts which must be executable
	exeinto $(ruby_fakegem_gemsdir)/gems/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}/scripts
	doexe scripts/*

	# generate vagrant-lxc sudo wrapper script for template
	${RUBY} \
		-I "${ED}"$(ruby_fakegem_gemsdir)/gems/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}/lib \
		"${FILESDIR}"/create_wrapper.rb \
		"${ED}"$(ruby_fakegem_gemsdir)/gems/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}/templates \
		|| die "Generate vagrant-lxc-wrapper failed with ${RUBY}"
	doexe vagrant-lxc-wrapper

	echo "%vagrant ALL=(root) NOPASSWD: $(ruby_fakegem_gemsdir)/gems/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}/scripts/vagrant-lxc-wrapper" >> "${ED}"etc/sudoers.d/vagrant-lxc
}

pkg_postinst() {
	# register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).add_plugin "vagrant-lxc";'

	elog "A sudoers file has been installed that allows users of the 'vagrant' group to create LXC containers."
	elog "    groupadd -r vagrant"
	elog "    usermod -aG vagrant <user>"
}

pkg_prerm() {
	# un-register plugin
	ruby -e '\
		require "vagrant/plugin/manager"; \
		Vagrant::Plugin::StateFile.new(Pathname.new(File.expand_path "/var/lib/vagrant/plugins.json")).remove_plugin "vagrant-lxc";'
}
