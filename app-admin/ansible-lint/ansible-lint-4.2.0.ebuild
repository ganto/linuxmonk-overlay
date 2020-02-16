# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Checks ansible playbooks for practices and behaviour that can be improved"
HOMEPAGE="https://github.com/ansible/ansible-lint"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
#SRC_URI="https://github.com/ansible/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-admin/ansible[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.37[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pip[${PYTHON_USEDEP}]
	>=dev-python/setuptools-41.4.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm_git_archive-1.0[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-4.6.6[${PYTHON_USEDEP}] )
"

src_prepare() {
	default
	# don't run coverage tests
	sed -i '/cov/d' pytest.ini
}

python_compile() {
	"${PYTHON}" -m pip wheel --wheel-dir "${T}"/wheeldir --use-pep517 --no-build-isolation --no-deps --disable-pip-version-check --progress-bar off --verbose .
}

python_install() {
	"${PYTHON}" -m pip install --root "${D}" --no-deps --disable-pip-version-check --progress-bar off --verbose --ignore-installed --no-warn-script-location "${T}"/wheeldir/*.whl
	python_optimize
}

python_test() {
	export PYTHONPATH=$(pwd)/lib
	py.test -v || die "Tests failed under ${EPYTHON}"
}
