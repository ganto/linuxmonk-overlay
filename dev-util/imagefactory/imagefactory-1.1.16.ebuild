# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 systemd

DESCRIPTION="System image generation tool"
HOMEPAGE="http://imgfac.org"
SRC_URI="https://github.com/redhat-imaging/imagefactory/archive/${P}-1.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="openstack rhevm"

RDEPEND="
	app-emulation/libguestfs[python,${PYTHON_SINGLE_USEDEP}]
	>=app-emulation/oz-0.12.0[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-libs/libxml2:2[python,${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		dev-python/pycurl[${PYTHON_USEDEP}]
		dev-python/zope-interface[${PYTHON_USEDEP}]
		openstack? ( dev-python/python-glanceclient[${PYTHON_USEDEP}] )
		rhevm? ( dev-python/ovirt-engine-sdk-python[${PYTHON_USEDEP}] )
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

python_compile() {
	distutils-r1_python_compile

	pushd imagefactory_plugins || die
	distutils-r1_python_compile
	popd || die
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

	pushd imagefactory_plugins || die
	distutils-r1_python_install

	einfo "Remove deprecated plugin 'EC2'"
	rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/EC2
	rm -r "${ED}"/etc/ssl/imagefactory/cert-ec2.pem
	rm "${ED}"/etc/imagefactory/jeos_images/ec2_fedora_jeos.conf
	rm "${ED}"/etc/imagefactory/jeos_images/ec2_rhel_jeos.conf

	einfo "Remove deprecated plugin 'Rackspace'"
	rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/Rackspace

	einfo "Remove deprecated plugin 'vSphere'"
	rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/vSphere

	einfo "Remove deprecated plugin 'Nova'"
	rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/Nova

	if ! use openstack; then
		einfo "Remove deselected plugin 'OpenStack'"
		rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/OpenStack
		rm "${ED}"/etc/imagefactory/jeos_images/rackspace_fedora_jeos.conf
		rm "${ED}"/etc/imagefactory/jeos_images/rackspace_rhel_jeos.conf
	fi
	if ! use rhevm; then
		einfo "Remove deselected plugin 'RHEVM'"
		rm -r "${ED}"$(python_get_sitedir)/imagefactory_plugins/RHEVM
	fi

	# Register remaining plugins
	for plugin in $(ls "${ED}"$(python_get_sitedir)/imagefactory_plugins/*/*.info); do
		dosym "../../../${plugin##${ED}}" /etc/imagefactory/plugins.d/$(basename ${plugin})
	done
	popd || die
}
