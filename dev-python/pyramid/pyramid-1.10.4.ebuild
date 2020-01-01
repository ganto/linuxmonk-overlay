# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A small open source Python web framework"
HOMEPAGE="http://www.pylonsproject.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="repoze"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/hupper-1.5[${PYTHON_USEDEP}]
	dev-python/plaster[${PYTHON_USEDEP}]
	dev-python/plaster-pastedeploy[${PYTHON_USEDEP}]
	>=dev-python/translationstring-0.4[${PYTHON_USEDEP}]
	>=dev-python/venusian-1.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.8.3[${PYTHON_USEDEP}]
	>=dev-python/zope-deprecation-3.5.0[${PYTHON_USEDEP}]
	>=dev-python/zope-interface-3.8.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/webtest-1.3.1[${PYTHON_USEDEP}]
		>=dev-python/zope-component-4.0[${PYTHON_USEDEP}]
	)
"

python_test() {
	pushd tests >/dev/null || die "Failed to change to test directory"
	# test will fail if dev-python/distro is installed, see Pylons/pyramid#3115
	py.test || die "Tests failed for ${EPYTHON}"
	popd >/dev/null
}
