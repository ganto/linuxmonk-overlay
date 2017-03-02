# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="NEWS README"

inherit ruby-fakegem

DESCRIPTION="Ruby bindings for libvirt"
HOMEPAGE="http://libvirt.org/ruby"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	app-emulation/libvirt
	test? ( app-emulation/qemu )
"

# Disable test suite for now, as it tries to access /var/lib/libvirt/images
RESTRICT="test"

#pkg_setup() {
#    if use test; then
#        local imagedir="/var/lib/libvirt/images"
#        local libvirt_group="libvirt"
#		if ! grep -qw ${libvirt_group} <<< $(id -nG) ||
#           [ "$( stat -c %G ${imagedir} )" != "${libvirt_group}" ] ||
#           [ "$( stat -c %a ${imagedir} | cut -b2 )" != "7" ]; then
#            eerror
#            eerror "\033[1;31m********************************************************\033[00m"
#            eerror "Test suite can only be run if the portage user '$( id -un )'"
#            eerror "is part of the '${libvirt_group}' group and the libvirt image"
#            eerror "directory '${imagedir}' is group writable."
#            eerror "\033[1;31m********************************************************\033[00m"
#            eerror
#			die
#		fi
#	fi
#}

each_ruby_configure() {
	${RUBY} -Cext/libvirt extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/libvirt
	cp ext/libvirt/*$(get_modname) lib/ || die
}
