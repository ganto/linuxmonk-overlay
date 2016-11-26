# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit cmake-utils python-r1 bash-completion-r1

DESCRIPTION="dnf is a package manager based on yum and libsolv"
HOMEPAGE="https://github.com/rpm-software-management/dnf"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${P}-1.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.1.10-cli-repolist-fix-showing-repository-name-with-disabl.patch )

S="${WORKDIR}/dnf-${P}-1"

CDEPEND="
	>=sys-libs/hawkey-0.6.1[${PYTHON_USEDEP}]
	<sys-libs/hawkey-0.7
"
RDEPEND="${CDEPEND}
	>=app-arch/rpm-4.12.0[${PYTHON_USEDEP}]
	>=dev-libs/libcomps-0.1.6[${PYTHON_USEDEP}]
	dev-python/iniparse[${PYTHON_USEDEP}]
	dev-python/pygpgme[${PYTHON_USEDEP}]
	>=sys-libs/librepo-1.7.16[${PYTHON_USEDEP}]
	!<=sys-apps/yum-3.4.3
	$(python_gen_cond_dep 'dev-python/pyliblzma[${PYTHON_USEDEP}]' python2_7)
"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	sys-devel/gettext
"

LANGS=(
	bg ca cs da de el es eu fi fr gu he hi hr hu id it ja ka kk ko
	lt ml mr ms nb nl pa pl pt ru sk sq sr sv th tr uk
)

for X in "${LANGS[@]}" ; do
	IUSE+=" l10n_${X}"
done
unset X

#src_prepare() {
#	default
#	if [[ -n ${L10N} ]] ; then
#		sed -i -e "/GETTEXT_CREATE_TRANSLATIONS/a ${L10N//-/_}" \
#			po/CMakeLists.txt || die
#	fi
#}

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

	bashcomp_alias dnf dnf-2 dnf-3

	python_setup
	local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )

	dosym dnf-${python_major} /usr/bin/dnf
	mv "${D}"/usr/bin/dnf-automatic-${python_major} "${D}"/usr/bin/dnf-automatic
	rm "${D}"/usr/bin/dnf-automatic-*

	einfo "Cleaning up locales..."
	for lang in ${LANGS[@]}; do
		use "l10n_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${D}"/usr/share/locale/${lang} || die
	done
	rm -Rf "${D}"/usr/share/locale/{bn_IN,en_GB,pt_BR,sr@latin,ur,zh_CN,zh_TW}
}
