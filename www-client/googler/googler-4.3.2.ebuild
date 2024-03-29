# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 bash-completion-r1

DESCRIPTION="Google Search, Google Site Search, Google News from the terminal"
HOMEPAGE="https://github.com/jarun/googler"
SRC_URI="https://github.com/jarun/${PN}/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/setproctitle[${PYTHON_USEDEP}]"

DOCS=( CHANGELOG README.md )

python_compile_all() {
	emake disable-self-upgrade
}

distutils-r1_python_compile() {
	python_fix_shebang googler
}

src_install() {
	python_foreach_impl python_doexe googler

	doman googler.1
	dodoc ${DOCS[@]}

	newbashcomp auto-completion/bash/googler-completion.bash googler
}
