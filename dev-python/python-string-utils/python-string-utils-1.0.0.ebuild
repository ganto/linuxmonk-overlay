# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Utility functions for strings checking and manipulation"
HOMEPAGE="https://github.com/daveoncode/python-string-utils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/wheel[${PYTHON_USEDEP}]"

DOCS=( README.md )

src_prepare() {
	default
	sed -i '/data_files/d' setup.py
}

distutils_enable_tests unittest
