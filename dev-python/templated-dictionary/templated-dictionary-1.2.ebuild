# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Dictionary with Jinja2 expansion"
HOMEPAGE="https://github.com/xsuchy/templated-dictionary"
SRC_URI="https://github.com/xsuchy/${PN}/archive/python-${P}-1.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}-python-${P}-1"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
"
