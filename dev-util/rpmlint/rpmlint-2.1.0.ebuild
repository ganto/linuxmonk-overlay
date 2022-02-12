# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_SINGLE_IMPL=1

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
		dev-python/pybeam[${PYTHON_USEDEP}]
		dev-python/pyenchant[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
		dev-python/zstd[${PYTHON_USEDEP}]
		sys-apps/file[python,${PYTHON_USEDEP}]
	')
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
		app-text/hunspell[l10n_en,l10n_cs]
		dev-libs/appstream-glib
		$(python_gen_cond_dep '
			dev-python/pytest-flake8[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		')
		dev-util/checkbashisms
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# remove pytest-cov dep
	sed -i -e "s/ --cov=rpmlint//" setup.cfg || die

	distutils-r1_python_prepare_all
}
