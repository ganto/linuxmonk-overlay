# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Utility functions for strings checking and manipulation"
HOMEPAGE="https://github.com/daveoncode/python-string-utils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-python/wheel[${PYTHON_USEDEP}]"

src_prepare() {
	default
	sed -i '/data_files/d' setup.py
}
