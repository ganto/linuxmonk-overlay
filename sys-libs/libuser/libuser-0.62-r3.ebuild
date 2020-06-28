# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit autotools python-r1

DESCRIPTION="A user and group account administration library"
HOMEPAGE="https://pagure.io/libuser"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.xz"
RESTRICT="mirror"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc ldap python sasl selinux"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.30:2
	dev-libs/popt
	ldap? ( net-nds/openldap )
	sasl? ( dev-libs/cyrus-sasl )
	selinux? ( sys-libs/libselinux )
	>=sys-devel/gettext-0.18.2
	sys-libs/glibc[nscd]
	sys-libs/pam
"
BDEPEND="
	doc? ( dev-util/gtk-doc )
	sys-devel/bison
	virtual/pkgconfig
"

src_prepare() {
	eapply "${FILESDIR}/${PV}-Fix-errors-with-Werror-format-security.patch"

	eapply_user
	eautoreconf

	if use python; then
		python_copy_sources
	fi
}

src_configure() {
	local mybaseconf=(
		--disable-static
		$(use_with ldap)
		$(use_with sasl)
		$(use_with selinux)
	)

	# set up the library build
	local myeconfargs=(
		${mybaseconf[@]}
		--without-python
	)

	if use doc; then
		myeconfargs+=( --enable-gtk-doc )
	fi

	econf ${myeconfargs[@]}

	# set up the python bindings build(s)
	if use python; then
		configure_py() {
			myeconfargs=(
				${mybaseconf[@]}
				--with-python
			)
			cd "${BUILD_DIR}"
			econf ${myeconfargs[@]}
		}
		python_foreach_impl configure_py
	fi
}

src_compile() {
	emake || die "emake failed"

	if use python; then
		compile_py() {
			local CFLAGS=${CFLAGS}

			python_is_python3 || CFLAGS+=" -fno-strict-aliasing"

			cd "${BUILD_DIR}"
			# couldn't figure out how to only compile the python parts,
			# therefore everything is compiled again
			emake || die "emake failed under ${EPYTHON}"
		}
		python_foreach_impl compile_py
	fi
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die

	if use python; then
		install_py() {
			# this will generate a rpath warning, but there is currently no
			# cleaner way to install without patching the build system
			python_domodule "${BUILD_DIR}"/python/.libs/libuser.so
		}
		python_foreach_impl install_py
	fi

	dodoc python/modules.txt
}
