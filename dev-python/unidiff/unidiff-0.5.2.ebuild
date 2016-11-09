# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Unified diff parsing/metadata extraction library"
HOMEPAGE="http://pypi.python.org/pypi/unidiff https://github.com/matiasb/python-unidiff"
SRC_URI="https://github.com/matiasb/python-unidiff/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( AUTHORS HISTORY README.md )

S="${WORKDIR}/python-${P}"

python_prepare_all() {
	distutils-r1_python_prepare_all

	# ebuild complains when trying to install tests
	sed -i "s/find_packages()/find_packages(exclude=('tests',))/" setup.py
}
