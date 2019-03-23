# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit python-r1

COMMIT_ID=deccf69d77245ddfde3ffaf36a743bf00828b36f

DESCRIPTION="Themes for Pelican"
HOMEPAGE="https://github.com/getpelican/pelican-themes"
SRC_URI="https://github.com/getpelican/${PN}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD GPL-3 MIT WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-text/pelican[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}-${COMMIT_ID}"

DOCS=( README.rst )

src_install() {
	default
	python_foreach_impl python_install
}

python_install() {
	insinto "$(python_get_sitedir)/pelican/themes"
	doins -r .
}
