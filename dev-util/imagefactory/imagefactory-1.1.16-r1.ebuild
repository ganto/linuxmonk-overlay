# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
# TODO: wrong path for datafiles
#DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 systemd

DESCRIPTION="System image generation tool"
HOMEPAGE="http://imgfac.org"
SRC_URI="https://github.com/redhat-imaging/imagefactory/archive/${P}-1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	app-emulation/libguestfs[python,${PYTHON_SINGLE_USEDEP}]
	>=app-emulation/oz-0.12.0[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-libs/libxml2:2[python,${PYTHON_USEDEP}]
		dev-python/cherrypy[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/pycurl[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.11-Adjust-certificate-path-for-Gentoo.patch
	"${FILESDIR}"/${PN}-1.1.14-utf8-config-id.patch
	"${FILESDIR}"/1.1.15-container-github-pr434.patch
	"${FILESDIR}"/1.1.16-encoding-github-pr438.patch
)

S="${WORKDIR}"/${PN}-${P}-1

distutils_enable_tests nose

python_test() {
	PYTHONPATH=${BUILD_DIR}/imgfac:${BUILD_DIR}/imagefactory_plugins nosetests --verbose || die "Tests failed for ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	rm -rf "${ED}"/etc/sysconfig
	rm -rf "${ED}"/etc/rc.d

	newconfd "${FILESDIR}"/imagefactoryd.confd imagefactoryd
	newinitd "${FILESDIR}"/imagefactoryd.initd imagefactoryd
	systemd_dounit "${FILESDIR}"/imagefactoryd.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/imagefactoryd.logrotate imagefactoryd

	dodir /etc/imagefactory/plugins.d
	keepdir /etc/imagefactory/plugins.d
}
