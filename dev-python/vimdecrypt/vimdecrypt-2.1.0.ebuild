# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1 pypi

DESCRIPTION="Command line tool for decrypting vim-blowfish-encrypted files"
HOMEPAGE="
	https://github.com/gertjanvanzwieten/vimdecrypt
	https://pypi.org/project/vimdecrypt/
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/blowfish[${PYTHON_USEDEP}]
"

DOCS=( README.md )

python_prepare_all() {
	# pyproject.toml lacks a [build-system] table; add it so the eclass
	# can resolve the PEP 517 backend (setup.cfg carries the rest of the
	# setuptools configuration).
	cat >> pyproject.toml <<-EOF

	[build-system]
	requires = ["setuptools"]
	build-backend = "setuptools.build_meta"
	EOF
	distutils-r1_python_prepare_all
}
