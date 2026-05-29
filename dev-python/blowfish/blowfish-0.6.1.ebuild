# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1 pypi

DESCRIPTION="Fast, efficient Blowfish cipher implementation in pure Python"
HOMEPAGE="
	https://github.com/jashandeep-sohi/python-blowfish
	https://pypi.org/project/blowfish/
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
