# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Unified diff parsing/metadata extraction library"
HOMEPAGE="https://pypi.python.org/pypi/unidiff https://github.com/matiasb/python-unidiff"
SRC_URI="https://github.com/matiasb/python-unidiff/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( AUTHORS HISTORY README.md )

S="${WORKDIR}/python-${P}"
