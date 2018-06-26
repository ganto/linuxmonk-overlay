# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit python-r1

DESCRIPTION="Reverse proxy grapher"
HOMEPAGE="https://github.com/mricon/rev-proxy-grapher"
SRC_URI="https://github.com/mricon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/pydotplus[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

src_install() {
	python_foreach_impl python_doscript rev-proxy-grapher.py

	dodoc README.rst
	docinto examples
	dodoc -r examples/.
}
