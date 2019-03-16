# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_USE_DEPEND=vapigen

inherit multilib-minimal meson vala

DESCRIPTION="A library full of GTK+ widgets for mobile phones"
HOMEPAGE="https://source.puri.sm/Librem5/libhandy"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3

	SRC_URI=""
	EGIT_REPO_URI="https://source.puri.sm/Librem5/${PN}.git"
else
	SRC_URI="https://source.puri.sm/Librem5/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-v${PV}"

	PATCHES=("${FILESDIR}/g-enum-no-auto-ptr.patch")
fi

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="introspection"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="dev-util/meson
	dev-util/glade
	gnome-base/gnome-desktop
	introspection? ( dev-libs/gobject-introspection )
	$(vala_depend)
"

BUILD_DIR="${S}/build"

src_prepare() {
	default

	vala_src_prepare --vala-api-version $(vala_best_api_version)
}

src_configure() {
	local emesonargs=(
		-Dexamples=false
		-Dtests=false
		$(meson_use introspection)
	)
	meson_src_configure
}
