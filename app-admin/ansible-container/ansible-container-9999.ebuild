# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_5 )

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
	>=dev-python/jinja-2.9[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.12[${PYTHON_USEDEP}]
	>=dev-python/requests-2[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	>=dev-python/structlog-16.1[${PYTHON_USEDEP}]
"
DEPEND="
	>=dev-python/setuptools-20.0.0[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.5.0[${PYTHON_USEDEP}]
"

DOCS=( AUTHORS CONTRIBUTORS.md EXAMPLES.md README.md ROADMAP.rst )

PATCHES=(
	"${FILESDIR}/${PN}-0.9.0-Remove-pip-requirements.patch"
)

src_prepare() {
	default

	# copy conductor build files which are packaged wrongly
	cp setup.py conductor-requirements.* container/docker/files
}

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

python_test() {
	# needs docker access
	test/run.sh || die "Running test with ${EPYTHON} failed."
}

pkg_postinst() {
	elog "There are multiple container orchestrators supported. Please manually install"
	elog "the required Python bindings:"
	elog
	elog "   docker:             >=dev-python/docker-py-2.1"
	elog "   kubernetes (k8s):   >=dev-python/openshift-restclient-python-0.0.1"
	elog "   openshift:          >=dev-python/openshift-restclient-python-0.0.1"
	elog
}
