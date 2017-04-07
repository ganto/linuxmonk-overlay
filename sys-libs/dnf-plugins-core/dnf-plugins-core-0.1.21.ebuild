# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit cmake-utils python-r1

DESCRIPTION="Core DNF plugins"
HOMEPAGE="https://github.com/rpm-software-management/dnf-plugins-core"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${P}-2.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

CDEPEND="${PYTHON_DEPS}"
DEPEND="${CDEPEND}
	sys-devel/gettext
"
RDEPEND="${CDEPEND}
	sys-apps/dnf[${PYTHON_USEDEP}]
	sys-libs/hawkey[${PYTHON_USEDEP}]
"

S="${WORKDIR}/dnf-plugins-core-${P}-2"

LANGS=( ca da de es eu fr hu it ja pl sr uk )

for X in "${LANGS[@]}" ; do
	IUSE+=" l10n_${X}"
done
unset X

src_configure() {
	dnf_src_configure_internal() {
		local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
		mycmakeargs=( -DPYTHON_DESIRED=${python_major} )

		cmake-utils_src_configure
	}
	python_foreach_impl dnf_src_configure_internal
}

src_compile() {
	dnf_src_compile_internal() {
		cmake-utils_src_compile
		cmake-utils_src_compile doc-man
	}
	python_foreach_impl dnf_src_compile_internal
}

src_install() {
	python_foreach_impl cmake-utils_src_install

	# cleanup leaked build files
	rm -Rf "${D}"/usr/share/man/man8/{CMakeFiles,.doctrees}

	einfo "Cleaning up locales..."
	for lang in ${LANGS[@]}; do
		use "l10n_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${D}"/usr/share/locale/${lang} || die
	done
	rm -Rf "${D}"/usr/share/locale/{pt_BR,zh_CN,zh_TW}
}
