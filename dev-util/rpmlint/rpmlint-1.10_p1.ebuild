# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )

inherit python-single-r1

DESCRIPTION="Tool for checking common errors in RPM packages"
HOMEPAGE="https://github.com/rpm-software-management/rpmlint"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${P%%_*}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	app-arch/bzip2
	app-arch/cpio
	app-arch/gzip
	app-arch/rpm[python,${PYTHON_USEDEP}]
	app-arch/xz-utils
	dev-python/pyenchant[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]
	dev-util/desktop-file-utils
	sys-apps/groff
	sys-devel/binutils:*
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	sys-apps/sed
	test? (
		dev-python/flake8[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P%%_*}-ignore-debuginfo-useless-provides.patch
	"${FILESDIR}"/${P%%_*}-flake-cleanups.patch
	"${FILESDIR}"/${P%%_*}-missing-files-exception.patch
	"${FILESDIR}"/${P%%_*}-py37mtime.patch
	"${FILESDIR}"/${P%%_*}-py37magic.patch
)

DOCS=( README.md config.example )

S="${WORKDIR}"/${PN}-${P%%_*}

src_prepare() {
	default

	python_fix_shebang .

	sed -i -e /MenuCheck/d Config.py
	cp -p config config.example
}

src_install() {
	default
	insinto /usr/share/rpmlint
	newins "${FILESDIR}"/${PN}.config config
	insinto /etc/rpmlint
	newins "${FILESDIR}"/${PN}-etc.config config
}
