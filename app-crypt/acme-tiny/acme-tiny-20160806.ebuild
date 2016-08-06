# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
inherit distutils-r1

inherit git-r3
KEYWORDS="~amd64"
EGIT_REPO_URI="https://github.com/diafygi/${PN}.git"
EGIT_COMMIT="5a7b4e79bc9bd5b51739c0d8aaf644f62cc440e6"

DESCRIPTION="A tiny, auditable script for Let's Encrypt's ACME Protocol"
HOMEPAGE="https://github.com/diafygi/acme-tiny"

LICENSE="MIT"
SLOT="0"

IUSE=""

DEPEND="dev-libs/openssl:0
	dev-python/setuptools_scm[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

src_prepare() {
	PATCHES=(
		"${FILESDIR}"/PR59-setup.py.patch
		"${FILESDIR}"/PR87-readmefix.patch
	)
	default
}
