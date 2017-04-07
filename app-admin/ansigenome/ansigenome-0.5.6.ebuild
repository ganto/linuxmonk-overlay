# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A tool to help you gather information and manage your Ansible roles"
HOMEPAGE="https://pypi.python.org/pypi/ansigenome https://github.com/nickjj/ansigenome"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/jinja
	dev-python/pyyaml"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
