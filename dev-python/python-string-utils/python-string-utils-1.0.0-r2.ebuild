# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..14} )

inherit distutils-r1

DESCRIPTION="Utility functions for strings checking and manipulation"
HOMEPAGE="https://github.com/daveoncode/python-string-utils"
SRC_URI="https://github.com/daveoncode/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

BDEPEND="dev-python/wheel[${PYTHON_USEDEP}]"

src_prepare() {
	default
	sed -i '/data_files/d' setup.py

	# Remove bogus executable permissions from non-script files. This corresponds
	# to the upstream pull request:
	#
	# Change files permissions to 644
	# https://github.com/daveoncode/python-string-utils/pull/4
	find . -type f -perm /0111 \
			-exec gawk '!/^#!/ { print FILENAME }; { nextfile }' '{}' '+' |
		xargs -r -t chmod -v a-x
}

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
