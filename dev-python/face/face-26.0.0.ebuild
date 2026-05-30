# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="A command-line application framework (and target CLI parser)"
HOMEPAGE="
	https://github.com/mahmoud/face
	https://pypi.org/project/face/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/boltons-20.0.0[${PYTHON_USEDEP}]
"
