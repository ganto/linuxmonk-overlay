# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 )

inherit distutils-r1

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible/ansible-lint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=app-admin/ansible-2.8[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.37[${PYTHON_USEDEP}]
	dev-python/typing-extensions
"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/pytest-6.0.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-2.1.0[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/pip[${PYTHON_USEDEP}]
	>=dev-python/setuptools-42.0.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_prepare() {
	default
	# don't run coverage tests
	sed -i '/cov/d' pytest.ini
}
