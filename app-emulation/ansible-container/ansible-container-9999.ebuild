# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Orchestrate, build, run, and ship Docker images built from Ansible playbooks"
HOMEPAGE="http://ansible.com/"
EGIT_REPO_URI="git://github.com/ansible/ansible-container.git"
EGIT_BRANCH="develop"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	>=app-emulation/docker-compose-1.7.0
	>=dev-python/docker-py-1.8.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-2.11[${PYTHON_USEDEP}]
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	>=app-emulation/docker-1.11.0
"
DEPEND="
	>=dev-python/setuptools-20.0.0[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${PN}-0.2-Remove-pip-requirements.patch" )

python_compile_all() {
	cd docs; emake man
	if use doc; then
		emake html
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all

	doman docs/_build/man/*.1
}
