# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit gnome2 meson python-any-r1

DESCRIPTION="A framework for easy media discovery and browsing"
HOMEPAGE="https://wiki.gnome.org/Projects/Grilo"

LICENSE="LGPL-2.1+"
SLOT="0.3"
KEYWORDS="~amd64"
IUSE="daap dvd examples chromaprint flickr freebox gnome-online-accounts lua subtitles test thetvdb tracker upnp-av vimeo +youtube"

REQUIRED_USE="
	flickr? ( gnome-online-accounts )
	lua? ( gnome-online-accounts )
"

# Bump gom requirement to avoid segfaults
RDEPEND="
	>=dev-libs/glib-2.44:2
	>=media-libs/grilo-0.3.6:${SLOT}=[network,playlist]
	media-libs/libmediaart:2.0
	>=dev-libs/gom-0.3.2

	dev-libs/gmime:3.0
	dev-libs/json-glib
	dev-libs/libxml2:2
	dev-db/sqlite:3

	chromaprint? ( media-plugins/gst-plugins-chromaprint:1.0 )
	daap? ( >=net-libs/libdmapsharing-2.9.12:3.0 )
	dvd? ( >=dev-libs/totem-pl-parser-3.4.1 )
	flickr? ( net-libs/liboauth )
	freebox? ( net-dns/avahi )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.17.91:= )
	lua? (
		>=dev-lang/lua-5.3
		app-arch/libarchive
		dev-libs/libxml2:2
		>=dev-libs/totem-pl-parser-3.4.1 )
	subtitles? ( net-libs/libsoup:2.4 )
	thetvdb? (
		app-arch/libarchive
		dev-libs/libxml2 )
	tracker? ( >=app-misc/tracker-0.10.5:= )
	youtube? (
		>=dev-libs/libgdata-0.9.1:=
		>=dev-libs/totem-pl-parser-3.4.1 )
	upnp-av? (
		net-libs/libsoup:2.4
		net-libs/dleyna-connector-dbus
		net-misc/dleyna-server )
	vimeo? (
		>=dev-libs/totem-pl-parser-3.4.1 )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/yelp-tools
	>=dev-util/gdbus-codegen-2.44
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
	lua? ( dev-util/gperf )
	upnp-av? ( test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/dbusmock[${PYTHON_USEDEP}]') ) )
"

python_check_deps() {
	use upnp-av && use test && has_version "dev-python/dbusmock[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use upnp-av && use test && python-any-r1_pkg_setup
}

# Override meson_use() to print yes|no instead of true|false
meson_use() {
	usex "$1" "-D${2-$1}=yes" "-D${2-$1}=no"
}

src_configure() {
	local emesonargs=(
		-Denable-bookmarks=yes
		-Denable-chromaprint=$(usex chromaprint yes no)
		-Denable-dleyna=$(usex upnp-av yes no)
		-Denable-dmap=$(usex daap yes no)
		-Denable-filesystem=yes
		-Denable-flickr=$(usex flickr yes no)
		-Denable-freebox=$(usex freebox yes no)
		-Denable-gravatar=yes
		-Denable-jamendo=yes
		-Denable-local-metadata=yes
		-Denable-lua-factory=$(usex lua yes no)
		-Denable-magnatune=yes
		-Denable-metadata-store=yes
		-Denable-opensubtitles=$(usex subtitles yes no)
		-Denable-optical-media=$(usex dvd yes no)
		-Denable-podcasts=yes
		-Denable-raitv=yes
		-Denable-shoutcast=yes
		-Denable-thetvdb=$(usex thetvdb yes no)
		-Denable-tmdb=yes
		-Denable-tracker=$(usex tracker yes no)
		-Denable-vimeo=$(usex vimeo yes no)
		-Denable-youtube=$(usex youtube yes no)
	)
	meson_src_configure
}
