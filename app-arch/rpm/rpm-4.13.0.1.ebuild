# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit eutils autotools flag-o-matic perl-module distutils-r1 versionator

DESCRIPTION="Red Hat Package Management Utils"
HOMEPAGE="http://www.rpm.org"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${P}-release.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="nls python doc caps lua acl selinux"

CDEPEND="!app-arch/rpm5
	app-arch/libarchive
	>=sys-libs/db-4.5:*
	>=sys-libs/zlib-1.2.3-r1
	>=app-arch/bzip2-1.0.1
	>=dev-libs/popt-1.7
	>=app-crypt/gnupg-1.2
	dev-libs/elfutils
	virtual/libintl
	>=dev-lang/perl-5.8.8
	dev-libs/nss
	python? ( ${PYTHON_DEPS} )
	nls? ( virtual/libintl )
	lua? ( >=dev-lang/lua-5.1.0:*[deprecated] )
	acl? ( virtual/acl )
	caps? ( >=sys-libs/libcap-2.0 )"

DEPEND="${CDEPEND}
	nls? ( sys-devel/gettext )
	doc? ( app-doc/doxygen )"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-rpm )"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

S="${WORKDIR}/rpm-${P}-release"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-4.11.0-autotools.patch \
		"${FILESDIR}"/${PN}-4.8.1-db-path.patch \
		"${FILESDIR}"/${PN}-4.9.1.2-libdir.patch \
		"${FILESDIR}"/${PN}-4.12.0-rpm2cpio-hack.patch

	# fix #356769
	sed -i 's:%{_var}/tmp:/var/tmp:' macros.in || die "Fixing tmppath failed"
	# fix #492642
	sed -i 's:@__PYTHON@:/usr/bin/python2:' macros.in || die "Fixing %__python failed"
	# fix build error
	sed -i '17 a #include "config.h"' tools/sepdebugcrcfix.c

	eautoreconf

	# Prevent automake maintainer mode from kicking in (#450448).
	touch -r Makefile.am preinstall.am
}

src_configure() {
	# configure must run with python 2.7
	use python && python_export python2_7 EPYTHON

	append-cppflags -I"${EPREFIX}/usr/include/nss" -I"${EPREFIX}/usr/include/nspr"
	econf \
		--without-selinux \
		--with-external-db \
		--without-beecrypt \
		$(use_enable python) \
		$(use_with doc hackingdocs) \
		$(use_enable nls) \
		$(use_with lua) \
		$(use_with caps cap) \
		$(use_with acl)
}

src_compile() {
	default_src_compile

	if use python; then
		python_build() {
			pushd python
			esetup.py build
			popd
		}
		python_foreach_impl python_build
	fi
}

src_install() {
	default

	if use python; then
		installation() {
			pushd python
			esetup.py install --skip-build --root "${D}"
			popd
		}
		python_foreach_impl installation
	fi

	# remove la files
	prune_libtool_files --all

	mv "${ED}"/bin/rpm "${ED}"/usr/bin
	rmdir "${ED}"/bin
	# fix symlinks to /bin/rpm (#349840)
	for binary in rpmquery rpmverify;do
		ln -sf rpm "${ED}"/usr/bin/${binary}
	done

	use nls || rm -rf "${ED}"/usr/share/man/??

	keepdir /usr/src/rpm/{SRPMS,SPECS,SOURCES,RPMS,BUILD}

	dodoc CHANGES CREDITS GROUPS README*
	if use doc; then
		pushd doc/hacking/html
		dohtml -p hacking -r .
		popd
		pushd doc/librpm/html
		dohtml -p librpm -r .
		popd
	fi

	# Fix perllocal.pod file collision
	perl_delete_localpod
}

pkg_postinst() {
	if [[ -f "${EROOT}"/var/lib/rpm/Packages ]] ; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		"${EROOT}"/usr/bin/rpmdb --rebuilddb --root="${EROOT}"
	else
		einfo "No RPM database found... Creating database..."
		"${EROOT}"/usr/bin/rpmdb --initdb --root="${EROOT}"
	fi
}
