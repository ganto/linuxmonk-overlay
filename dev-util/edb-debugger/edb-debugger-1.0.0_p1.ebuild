# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

QHEXVIEW_COMMIT=2a8258d0721e0c4a811f6318a265a73c13222fc9

MY_PV=${PV%%_p*}
MY_P=${PN}-${MY_PV}

DESCRIPTION="edb is a cross platform x86/x86-64 debugger, inspired by Ollydbg"
HOMEPAGE="https://github.com/eteran/edb-debugger"
SRC_URI="https://github.com/eteran/${PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	https://github.com/eteran/${PN}/commit/fb1f13bd182063d7b4065e470339319e930a4eac.patch -> ${MY_P}-Removing-Qt4-support.patch
	https://github.com/eteran/qhexview/archive/${QHEXVIEW_COMMIT}.tar.gz -> qhexview-${QHEXVIEW_COMMIT:0:7}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/boost
	>=dev-libs/capstone-3.0.4
	dev-qt/qtcore:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	>=media-gfx/graphviz-2.38.0
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/pkgconfig
"

PATCHES=(
	"${DISTDIR}"/${MY_P}-Removing-Qt4-support.patch
	"${FILESDIR}"/${MY_P}-Remove-qjson4-reference.patch
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	cmake-utils_src_prepare

	rmdir src/qhexview
	ln -s ../../qhexview-${QHEXVIEW_COMMIT} src/qhexview
}
