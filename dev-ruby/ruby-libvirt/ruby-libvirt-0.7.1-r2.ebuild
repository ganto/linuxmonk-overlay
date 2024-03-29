# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="NEWS README"
RUBY_FAKEGEM_EXTENSIONS=(ext/libvirt/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Ruby bindings for libvirt"
HOMEPAGE="http://libvirt.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-emulation/libvirt
	test? ( app-emulation/qemu )
"

# Disable test suite for now, as it tries to access /var/lib/libvirt/images
RESTRICT="test"

all_ruby_prepare() {
	# Fix incorrect include
	# https://gitlab.com/libvirt/libvirt-ruby/-/merge_requests/4
	sed -i '/^#include </ s|\(st\.h\)|ruby/\1|' ext/libvirt/common.c
	sed -i '/^#include </ s|\(st\.h\)|ruby/\1|' ext/libvirt/domain.c
}

each_ruby_configure() {
	${RUBY} -Cext/libvirt extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/libvirt CFLAGS="${CFLAGS} -fPIC" \
		archflag="${LDFLAGS}" || die "make native library failed"
	cp -l ext/libvirt/*$(get_modname) lib/ || die
}
