# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A tool to help you gather information and manage your Ansible roles"
HOMEPAGE="https://pypi.python.org/pypi/ansigenome https://github.com/nickjj/ansigenome"
EGIT_COMMIT="dc415c5ad34fee024900e5afaa2b1ff4ab29f158"
SRC_URI="https://github.com/nickjj/ansigenome/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/jinja
	dev-python/pyyaml"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
