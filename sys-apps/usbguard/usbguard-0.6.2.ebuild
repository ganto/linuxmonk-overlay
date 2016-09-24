# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools eutils

DESCRIPTION="Software framework for implementing USB device authorization policies"
HOMEPAGE="https://dkopecek.github.io/usbguard/"
SRC_URI="https://github.com/dkopecek/usbguard/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+dbus debug gcrypt +qt4 qt5 static test"

RDEPEND="
	gcrypt? ( >=dev-libs/libgcrypt-1.5.0:0 )
	!gcrypt? ( >=dev-libs/libsodium-0.4.5 )
	>=dev-libs/protobuf-2.5.0
	qt4? ( dev-qt/qtcore:4 dev-qt/qtgui:4 dev-qt/qtsvg:4 )
	qt5? ( dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtwidgets:5 dev-qt/qtsvg:5 )
	dbus? ( sys-auth/polkit[introspection]
		>=dev-libs/dbus-glib-0.100
		dev-libs/glib:2
		dev-libs/libxml2
		dev-libs/libxslt
		dev-util/gdbus-codegen
		sys-apps/dbus )
	>=sys-cluster/libqb-0.16.0
	>=sys-libs/libcap-ng-0.7.0
	>=sys-libs/libseccomp-2.0.0
	>=virtual/libudev-200
"
DEPEND="${RDEPEND}
	dev-cpp/catch
	dev-cpp/pegtl
	virtual/pkgconfig
"

REQUIRED_USE="
	qt4? ( !qt5 )
	qt5? ( !qt4 )
"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	# file should be generated from .in file
	rm usbguard-daemon.conf

	default_src_prepare
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--without-bundled-catch
		--without-bundled-pegtl
		$(use_with dbus)
		$(use_enable static)
		$(use_enable debug debug-build)
		--enable-systemd
	)
	if use gcrypt; then
		myeconfargs+=(--with-crypto-library=gcrypt)
	else
		myeconfargs+=(--with-crypto-library=sodium)
	fi
	use qt4 && myeconfargs+=(--with-gui-qt=qt4)
	use qt5 && myeconfargs+=(--with-gui-qt=qt5)
	if ! use qt4 && ! use qt5; then
		myeconfargs+=(--with-gui-qt=no)
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	use qt4 && export QT_SELECT=4
	use qt5 && export QT_SELECT=5

	default_src_compile
}

src_test() {
	emake check || die "Testsuite failed"
}

src_install() {
	default_src_install
	prune_libtool_files
}

pkg_postinst() {
	elog "To generate an initial policy for your system, run:"
	elog "  usbguard generate-policy > /etc/usbguard/rules.conf"
}
