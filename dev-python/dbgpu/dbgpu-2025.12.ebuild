# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Database of over 2000 GPUs with architecture, manufacturing, API support and performance details"
HOMEPAGE="
	https://github.com/painebenjamin/dbgpu
	https://pypi.org/project/dbgpu/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="fuzz"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	fuzz? (
		dev-python/thefuzz[${PYTHON_USEDEP}]
	)
"
