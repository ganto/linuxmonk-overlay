# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python2_7 python3_{4,5} )

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
	app-arch/pigz
	app-arch/rpm[python,${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	sys-apps/usermode
	|| ( sys-apps/dnf sys-apps/yum )
	$(python_gen_cond_dep 'dev-python/pyliblzma[${PYTHON_USEDEP}]' 'python2_7' )
"

S="${WORKDIR}/mock-${P}-1"

src_compile() {
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
}

src_install() {
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

	dobashcomp etc/bash_completion.d/mock

	insinto /etc/ssl/mock
	doins etc/pki/*

	python_domodule py/mockbuild

	doman docs/mockchain.1 docs/mock.1
}

pkg_postinst() {
	enewgroup mock
}
