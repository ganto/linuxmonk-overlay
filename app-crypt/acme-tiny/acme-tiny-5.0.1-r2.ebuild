# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )

DISTUTILS_USE_PEP517="setuptools"

inherit distutils-r1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/diafygi/${PN}.git"
else
	SRC_URI="https://github.com/diafygi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="A tiny, auditable script for Let's Encrypt's ACME Protocol"
HOMEPAGE="https://github.com/diafygi/acme-tiny"

LICENSE="MIT"
SLOT="0"
IUSE=""

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"
RDEPEND="dev-libs/openssl:0"

# Tests require a local ACME server to be set up.
RESTRICT="test"

pkg_setup() {
	if [[ ${PV} != 9999 ]]; then
		export SETUPTOOLS_SCM_PRETEND_VERSION="${PV}"
	fi
}

src_prepare() {
	sed -i 's|#!/usr/bin/sh|#!/bin/sh|g' README.md || die

	distutils-r1_src_prepare
}

pkg_postinst() {
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "$v" "-lt" "4.0.3" || ver_test "$v" "-ge" "9999"; then
			einfo "The --account-email flag has been changed to --contact and"
			einfo "has different syntax."
			einfo "Please update your scripts accordingly"
		fi
	done
}
