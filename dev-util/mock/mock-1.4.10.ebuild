# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1 user bash-completion-r1

DESCRIPTION="Builds RPM packages inside chroots"
HOMEPAGE="https://github.com/rpm-software-management/mock"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${P}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	app-arch/createrepo_c
	app-arch/pigz
	app-arch/rpm[lua,python,${PYTHON_USEDEP}]
	app-misc/distribution-gpg-keys
	dev-python/distro[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pyliblzma[${PYTHON_USEDEP}]' 'python2_7' )
	dev-python/pyroute2[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	sys-apps/iproute2
	sys-apps/usermode
	|| ( ( sys-apps/dnf sys-libs/dnf-plugins-core ) sys-apps/yum )

"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.8-Fix-path.patch
)

S="${WORKDIR}/mock-${P}-1"

src_compile() {
	pushd mock
	for i in py/mock.py py/mockchain.py; do
		sed -i -e "s|^__VERSION__\s*=.*|__VERSION__=\"${PV}\"|" ${i}
		sed -i -e "s|^SYSCONFDIR\s*=.*|SYSCONFDIR=\"/etc\"|" ${i}
		sed -i -e "s|^PYTHONDIR\s*=.*|PYTHONDIR=\"$(python_get_sitedir)\"|" ${i}
		sed -i -e "s|^PKGPYTHONDIR\s*=.*|PKGPYTHONDIR=\"$(python_get_sitedir)/mockbuild\"|" ${i}
	done
	for i in docs/mock.1 docs/mockchain.1; do
		sed -i -e "s|@VERSION@|${PV}\"|" ${i}
	done

	# Gentoo doesn't know /etc/pki
	sed -i -e "s|/etc/pki/mock|/etc/ssl/mock|g" etc/mock/*
	popd
}

src_install() {
	pushd mock
	python_scriptinto /usr/bin
	python_newscript py/mockchain.py mockchain

	python_scriptinto /usr/libexec/mock
	python_newscript py/mock.py mock

	dosym consolehelper /usr/bin/mock

	insinto /etc/pam.d
	doins etc/pam/*

	insinto /etc/mock
	doins etc/mock/*

	insinto /etc/security/console.apps
	doins etc/consolehelper/mock

	insinto /etc/ssl/mock
	doins etc/pki/*

	python_domodule py/mockbuild

	doman docs/mockchain.1 docs/mock.1

	keepdir /var/lib/mock

	dobashcomp etc/bash_completion.d/mock
	bashcomp_alias mock mock.py
	bashcomp_alias mock mockchain
	bashcomp_alias mock mockchain.py
	popd

	pushd mock-core-configs
	insinto /etc/mock
	doins etc/mock/*
	popd
}

pkg_postinst() {
	enewgroup mock

	elog
	elog "Mock includes a number of plugins which might need additional runtime"
	elog "dependencies:"
	elog "  nspawn:        sys-apps/systemd"
	elog "  ccache         dev-util/ccache"
	elog "  compress_logs  app-arch/xz-utils"
	elog "  lvm_root       sys-fs/lvm2"
	elog "  scm:           dev-vcs/git"
	elog "                 dev-vcs/subversion"
	elog "                 dev-vcs/cvs"
	elog "  hwinfo:        sys-apps/util-linux"
	elog "                 sys-apps/coreutils"
	elog "                 sys-process/procps"
	elog
	elog "To use mock as a non-root user, add yourself to the 'mock' group:"
	elog "  usermod -aG mock youruser"
	elog
}
