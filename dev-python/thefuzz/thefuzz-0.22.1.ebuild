# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Fuzzy string matching in Python"
HOMEPAGE="
	https://github.com/seatgeek/thefuzz
	https://pypi.org/project/thefuzz/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/rapidfuzz-3.0.0[${PYTHON_USEDEP}]
"
