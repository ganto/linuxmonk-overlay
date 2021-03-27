# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_USE_DEPEND="vapigen"

inherit bash-completion-r1 check-reqs gnome.org gnome2-utils meson multilib-minimal systemd udev vala

DESCRIPTION="System service to accurately color manage input and output devices"
HOMEPAGE="https://www.freedesktop.org/software/colord/"
SRC_URI="https://www.freedesktop.org/software/colord/releases/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0/2" # subslot = libcolord soname version
KEYWORDS="~amd64"

IUSE="argyllcms examples extra-print-profiles scanner systemd +udev vala"
REQUIRED_USE="
	extra-print-profiles? ( argyllcms )
	scanner? ( udev )
"

DEPEND="
	>=dev-libs/glib-2.45.8:2[${MULTILIB_USEDEP}]
	>=dev-libs/gobject-introspection-0.9.8:=
	>=media-libs/lcms-2.6:2=[${MULTILIB_USEDEP}]
	dev-db/sqlite:3=[${MULTILIB_USEDEP}]
	>=dev-libs/libgusb-0.2.7[introspection,${MULTILIB_USEDEP}]
	dev-libs/libgudev:=[${MULTILIB_USEDEP}]
	virtual/libudev:=[${MULTILIB_USEDEP}]
	>=sys-auth/polkit-0.104
	argyllcms? ( media-gfx/argyllcms )
	scanner? (
		media-gfx/sane-backends
		sys-apps/dbus
	)
	systemd? ( >=sys-apps/systemd-44:0= )
	udev? ( virtual/udev )
"
RDEPEND="${DEPEND}
	acct-group/colord
	acct-user/colord
	!<=media-gfx/colorhug-client-0.1.13
	!media-gfx/shared-color-profiles
"
BDEPEND="
	acct-group/colord
	acct-user/colord
	dev-libs/libxslt
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	extra-print-profiles? ( media-gfx/argyllcms )
	vala? ( $(vala_depend) )
"
# These dependencies are required to build native build-time programs.
BDEPEND="${BDEPEND}
	dev-libs/glib:2
	media-libs/lcms
"

# FIXME: needs pre-installed dbus service files
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PV}-argyll-Adapt-to-Gentoo-paths.patch
)

# According to upstream comment in colord.spec.in, building the extra print
# profiles requires >=4G of memory
CHECKREQS_MEMORY="4G"

pkg_pretend() {
	use extra-print-profiles && check-reqs_pkg_pretend
}

pkg_setup() {
	use extra-print-profiles && check-reqs_pkg_setup
}

src_prepare() {
	default
	if use vala; then
		vala_src_prepare
		sed -i -e "s:'vapigen':'vapigen-$(vala_best_api_version)':" meson.build
	fi
}

multilib_src_configure() {
	local emesonargs=(
		--localstatedir="${EPREFIX}"/var
		-Dbash_completion=false
		-Ddaemon_user=colord
		-Ddocs=false
		-Dlibcolordcompat=true
		-Dsession_example=false
		-Dargyllcms_sensor=$(multilib_native_usex argyllcms true false)
		-Dprint_profiles=$(multilib_native_usex extra-print-profiles true false)
		-Dsane=$(multilib_native_usex scanner true false)
		-Dsystemd=$(multilib_native_usex systemd true false)
		-Dudev_rules=$(multilib_native_usex udev true false)
		-Dvapi=$(multilib_native_usex vala true false)
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}

multilib_src_install_all() {
	einstalldocs

	newbashcomp data/colormgr colormgr

	# Ensure config and profile directories exist and /var/lib/colord/*
	# is writable by colord user
	keepdir /var/lib/color{,d}/icc
	fowners colord:colord /var/lib/colord{,/icc}

	if use examples; then
		docinto examples
		dodoc examples/*.c
	fi
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
