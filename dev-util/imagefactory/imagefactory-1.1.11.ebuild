# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 systemd

DESCRIPTION="System image generation tool"
HOMEPAGE="http://imgfac.org"
SRC_URI="https://github.com/redhat-imaging/imagefactory/archive/${P}-1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ec2 openstack nova rackspace rhevm test vmware"

RDEPEND="${PYTHON_DEPS}
	app-emulation/libguestfs[python,python_targets_python2_7?]
	>=app-emulation/oz-0.12.0[${PYTHON_USEDEP}]
	dev-libs/libxml2:2[python,${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/oauth2[${PYTHON_USEDEP}]
	dev-python/pastedeploy[${PYTHON_USEDEP}]
	dev-python/pycurl[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	ec2? (
		dev-python/boto[${PYTHON_USEDEP}]
		dev-util/euca2ools[${PYTHON_USEDEP}]
	)
	nova? ( dev-python/rackspace-novaclient[${PYTHON_USEDEP}] )
	openstack? ( dev-python/python-glanceclient[${PYTHON_USEDEP}] )
	rackspace? (
		dev-python/rackspace-novaclient[${PYTHON_USEDEP}]
		dev-python/pyrax[${PYTHON_USEDEP}]
	)
	rhevm? (
		dev-python/ovirt-engine-sdk-python[${PYTHON_USEDEP}]
	)
	vmware? (
		dev-python/psphere[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}"/${P}-Adjust-certificate-path-for-Gentoo.patch
)

S="${WORKDIR}"/${PN}-${P}-1

python_test() {
	PYTHONPATH=${BUILD_DIR}/imgfac:${BUILD_DIR}/imagefactory_plugins nosetests --verbose || die "Tests failed for ${EPYTHON}"
}

python_compile() {
	distutils-r1_python_compile

	pushd imagefactory_plugins || die
	distutils-r1_python_compile
	popd || die
}

python_install() {
	distutils-r1_python_install

	systemd_dounit "${FILESDIR}"/imagefactoryd.service

	pushd imagefactory_plugins || die
	distutils-r1_python_install
	if ! use ec2; then
		einfo "Remove deselected plugin 'EC2'"
		rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/EC2
	fi
	if ! use openstack; then
		einfo "Remove deselected plugin 'OpenStack'"
		rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/OpenStack
	fi
	if ! use nova; then
		einfo "Remove deselected plugin 'Nova'"
		rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/Nova
	fi
	if ! use rackspace; then
		einfo "Remove deselected plugin 'Rackspace'"
		rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/Rackspace
	fi
	if ! use rhevm; then
		einfo "Remove deselected plugin 'RHEVM'"
		rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/RHEVM
	fi
	if ! use vmware; then
		einfo "Remove deselected plugin 'vSphere'"
		rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/vSphere
	fi
	popd || die
}
