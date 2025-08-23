# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Tool for checking common errors in RPM packages"
HOMEPAGE="https://github.com/rpm-software-management/rpmlint"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/bzip2
	app-arch/cpio
	app-arch/gzip
	app-arch/rpm[python,${PYTHON_SINGLE_USEDEP}]
	app-arch/xz-utils
	dev-lang/perl:*
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pybeam[${PYTHON_USEDEP}]
		dev-python/pyenchant[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/tomli[${PYTHON_USEDEP}]
		dev-python/tomli-w[${PYTHON_USEDEP}]
		dev-python/zstandard[${PYTHON_USEDEP}]
		sys-apps/file[python,${PYTHON_USEDEP}]
	')
	dev-util/checkbashisms
	dev-util/desktop-file-utils
	sys-apps/groff
	sys-devel/binutils:*
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/sed
	test? (
		${RDEPEND}
		app-shells/dash
		app-text/hunspell[l10n_en,l10n_cs,l10n_fr]
		dev-libs/appstream-glib
		$(python_gen_cond_dep '
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		')
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# remove pytest-cov dep
	sed -i -e "/--cov=rpmlint/d" pytest.ini || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/xdg/rpmlint
	doins "${FILESDIR}"/*.toml
}
