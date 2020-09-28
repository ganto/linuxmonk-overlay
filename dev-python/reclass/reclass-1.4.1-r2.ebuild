# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A recursive external node classifier for automation tools"
HOMEPAGE="https://pypi.python.org/pypi/reclass https://github.com/madduck/reclass"
SRC_URI="https://github.com/madduck/${PN}/archive/${P}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"

S="${WORKDIR}/reclass-${P}"
