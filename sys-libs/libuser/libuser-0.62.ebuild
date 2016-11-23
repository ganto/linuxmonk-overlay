# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit autotools-utils python-r1

DESCRIPTION="A user and group account administration library"
HOMEPAGE="https://fedorahosted.org/libuser/"
SRC_URI="https://fedorahosted.org/releases/l/i/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc ldap python sasl selinux"

CDEPEND="
	>=dev-libs/glib-2.30:2
	dev-libs/popt
	ldap? ( net-nds/openldap )
	python? ( ${PYTHON_DEPS} )
	sasl? ( dev-libs/cyrus-sasl )
	selinux? ( sys-libs/libselinux )
	>=sys-devel/gettext-0.18.2
	sys-libs/glibc[nscd]
	virtual/pam
"
DEPEND="${CDEPEND}
	doc? ( dev-util/gtk-doc )
	sys-devel/bison
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}"

src_configure() {
	local myconf=(
		--disable-static
		$(use_with ldap)
		$(use_with sasl)
		$(use_with selinux)
	)

	# set up the library build
	local myeconfargs=(
		${myconf[@]}
		--without-python
	)

	if use doc; then
		myeconfargs+=( --enable-gtk-doc )
	fi

	autotools-utils_src_configure

	# set up the python bindings build(s)
	if use python; then
		myeconfargs=(
			${myconf[@]}
			--with-python
		)
		python_foreach_impl autotools-utils_src_configure
	fi
}

src_compile() {
	autotools-utils_src_compile

	if use python; then
		python_compile() {
			local CFLAGS=${CFLAGS}

			python_is_python3 || CFLAGS+=" -fno-strict-aliasing"

			# couldn't figure out how to only compile the python parts,
			# therefore everything is compiled again
			autotools-utils_src_compile
		}
		python_foreach_impl python_compile
	fi
}

src_install() {
	autotools-utils_src_install

	if use python; then
		installation() {
			# this will generate a rpath warning, but there is currently no
			# cleaner way to install without patching the build system
			python_domodule "${BUILD_DIR}"/python/.libs/libuser.so
		}
		python_foreach_impl installation
	fi

	dodoc python/modules.txt
}
