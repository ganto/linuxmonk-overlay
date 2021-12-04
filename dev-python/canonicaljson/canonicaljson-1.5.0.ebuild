# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Canonical JSON"
HOMEPAGE="https://github.com/matrix-org/python-canonicaljson https://pypi.org/project/canonicaljson/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/frozendict-1.0[${PYTHON_USEDEP}]
	>=dev-python/simplejson-3.14.0[${PYTHON_USEDEP}]
"

DOCS=( CHANGES.md README.rst )

distutils_enable_tests nose
