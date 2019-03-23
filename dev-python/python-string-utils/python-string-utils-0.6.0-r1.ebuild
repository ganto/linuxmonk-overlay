# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Utility functions for strings checking and manipulation"
HOMEPAGE="https://github.com/daveoncode/python-string-utils"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PV}-Change-file-permissions-to-644.patch )

DOCS=( README.md )

src_prepare() {
	default
	sed -i '/data_files/d' setup.py
}
