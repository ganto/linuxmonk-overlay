# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Review Ansible inventory files, roles, modules and playbooks"
HOMEPAGE="https://pypi.python.org/pypi/ansible-review https://github.com/willthames/ansible-review"
SRC_URI="https://github.com/willthames/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	>=app-admin/ansible-lint-3.4.1[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/flake8[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/unidiff[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}] )
"

python_test() {
	nosetests
}
