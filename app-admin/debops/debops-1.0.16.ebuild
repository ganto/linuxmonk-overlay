# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DEBOPS_GIT_COMMIT="07d8b6112bfd3d869fe0db52b6ba8ee68abcbc18"

DESCRIPTION="Your Debian-based data center in a box"
HOMEPAGE="https://debops.org/"
SRC_URI="https://github.com/debops/debops/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RDEPEND="
	app-admin/ansible[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/dnspython[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/netaddr[${PYTHON_USEDEP}]
	dev-python/passlib[${PYTHON_USEDEP}]
	dev-python/python-ldap[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/nose2
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
}

python_compile_all() {
	if use doc; then
		pushd docs || die
		sphinx-build -d _build/doctrees . _build/html || die "Failed to build documentation"
		popd || die
	fi
}

python_test() {
	einfo "Testing 'debops-tools'"
	emake test-debops-tools || die "Testing 'debops-tools' failed for ${EPYTHON}"
	einfo "Testing Ansible playbook syntax"
	emake test-playbook-syntax || die "Testing playbook syntax failed with:\n$(ansible --version)"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
