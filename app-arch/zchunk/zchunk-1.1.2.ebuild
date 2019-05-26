# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Compressed file format that allows easy deltas"
HOMEPAGE="https://github.com/zchunk/zchunk"
SRC_URI="https://github.com/zchunk/zchunk/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-arch/zstd
	dev-libs/openssl:0
	net-misc/curl
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default

	# Remove bundled sha libraries
	rm -rf src/lib/hash/sha*
}

src_configure() {
	local emesonargs=(
		-Dwith-openssl=enabled
		-Dwith-zstd=enabled
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	insinto /usr/libexec
	doins contrib/gen_xml_dictionary
}
