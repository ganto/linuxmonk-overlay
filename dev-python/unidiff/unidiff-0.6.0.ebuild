# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Unified diff parsing/metadata extraction library"
HOMEPAGE="https://pypi.python.org/pypi/unidiff https://github.com/matiasb/python-unidiff"
SRC_URI="https://github.com/matiasb/python-unidiff/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( AUTHORS HISTORY README.rst )

S="${WORKDIR}/python-${P}"
