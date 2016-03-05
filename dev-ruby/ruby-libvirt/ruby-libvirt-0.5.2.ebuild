# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

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

each_ruby_configure() {
	${RUBY} -Cext/libvirt extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/libvirt
	cp ext/libvirt/*$(get_modname) lib/ || die
}
