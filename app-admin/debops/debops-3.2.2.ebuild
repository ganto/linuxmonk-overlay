# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DEBOPS_GIT_COMMIT="1e1414b731fc37fbbefe21b97b57f4507e973924"

DESCRIPTION="Your Debian-based data center in a box"
HOMEPAGE="https://debops.org/"
SRC_URI="https://github.com/debops/debops/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"
RESTRICT="
	mirror
	!test? ( test )
"

RDEPEND="
	>=app-admin/ansible-2.16[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/passlib[${PYTHON_USEDEP}]
	dev-python/python-ldap[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]

	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}] )
	test? (
		app-admin/ansible[${PYTHON_USEDEP}]
		dev-python/nose2[${PYTHON_USEDEP}]
		dev-python/python-dotenv[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.rst CODEOWNERS CONTRIBUTING.rst DEVELOPMENT.rst README.md Dockerfile Vagrantfile )

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.2-Skip-edit_url.patch
)

src_prepare() {
	default

	# replace os.popen('git') calls
	sed -i \
		-e "s/^\(git_commit_id = \).*$/\1'${DEBOPS_GIT_COMMIT}'/" \
		-e "s/^\(release = \).*$/\1'${PV}'/g" \
		docs/conf.py

	# fix tests
	sed -i -e "s/nose2-3/nosetests/g" Makefile
}

python_compile_all() {
	pushd docs >/dev/null || die
	sphinx-build -b man -d _build/doctrees -n -t manpages -W . _build/man || die "Failed to build man-pages"
	if use doc; then
		sphinx-build -b html -d _build/doctrees -n -W -T -vvv . _build/html || die "Failed to build documentation"
	fi
	popd || die >/dev/null
}

python_test() {
	einfo "Testing 'debops-tools'"
	emake test-debops-tools || die "Testing 'debops-tools' failed for ${EPYTHON}"
	einfo "Testing Ansible playbook syntax"
	emake test-playbook-syntax || die "Testing playbook syntax failed with:\n$(ansible --version)"
	einfo "Testing Ansible plugins"
	emake test-debops-ansible_plugins || die "Testing Ansible plugins failed with:\n$(ansible --version)"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
