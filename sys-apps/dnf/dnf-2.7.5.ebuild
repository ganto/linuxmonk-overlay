# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit cmake-utils python-r1 bash-completion-r1

DESCRIPTION="DNF is a package manager based on yum and libsolv"
HOMEPAGE="https://github.com/rpm-software-management/dnf"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

# the upstream app-arch/rpm uses python-single-r1 eclass and only supports one
# python implementation, don't restrict ourselves and support multiple python
# implementations in case rpm will ever switch to python-r1 eclass
CDEPEND="
	>=app-arch/rpm-4.13.0[python,python_targets_python2_7?,python_targets_python3_5?,python_targets_python3_6?]
	>=app-crypt/gpgme-1.10.0[python,${PYTHON_USEDEP}]
	>=dev-libs/libcomps-0.1.8[${PYTHON_USEDEP}]
	dev-python/iniparse[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pyliblzma[${PYTHON_USEDEP}]' python2_7)
	>=sys-libs/libdnf-0.10.1[${PYTHON_USEDEP}]
	>=sys-libs/librepo-1.7.19[${PYTHON_USEDEP}]
"
RDEPEND="${CDEPEND}
	!!sys-apps/yum
"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	dev-python/sphinx
	sys-devel/gettext
	test? ( dev-python/nose )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.5-Allow-to-set-cacheonly-from-commands-and-conf-RhBug-.patch
	"${FILESDIR}"/${PN}-2.7.5-Remove-redundant-conf-option-cacheonly.patch
	"${FILESDIR}"/${PN}-2.7.5-Remove-unnecessary-code-for-set-cacheonly.patch
)

LANGS=(
	ar bg ca cs da de el es eu fi fr gu he hi hr hu id it ja ka kk ko
	lt ml mr ms nb nl pa pl pt ru sk sq sr sv th tr uk
)

for X in "${LANGS[@]}" ; do
	IUSE+=" l10n_${X}"
done
unset X

src_prepare() {
	cmake-utils_src_prepare
	python_copy_sources
}

src_configure() {
	dnf_src_configure_internal() {
		local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
		mycmakeargs=( -DPYTHON_DESIRED:str=${python_major} )

		cmake-utils_src_configure
	}
	python_foreach_impl dnf_src_configure_internal
}

src_compile() {
	dnf_src_compile_internal() {
		# make sure we get a processed const.py
		cp -p "${S}"/dnf/const.py "${BUILD_DIR}"/dnf

		cmake-utils_src_compile
		cmake-utils_src_compile doc-man

		# fix shebang of temporary build python path
		if python_is_python3 ; then
			sed -i '1 s|^.*$|#!/usr/bin/python3|' "${S}"/bin/*-3
		else
			sed -i '1 s|^.*$|#!/usr/bin/python2|' "${S}"/bin/*-2
		fi
	}
	python_foreach_impl dnf_src_compile_internal
}

src_test() {
	dnf_src_test_internal() {
		cmake-utils_src_make DESTDIR="${WORKDIR}-test-${EPYTHON}" install
		PYTHONPATH="${WORKDIR}-test-${EPYTHON}"/$(python_get_sitedir) nosetests -s tests || die "tests failed with ${EPYTHON}"
	}
	python_foreach_impl dnf_src_test_internal
}

src_install() {
	python_foreach_impl cmake-utils_src_install

	dnf_src_install_optimize() {
		python_optimize "${ED}"/$(python_get_sitedir)
	}
	python_foreach_impl dnf_src_install_optimize

	bashcomp_alias dnf dnf-2 dnf-3

	python_setup
	local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )

	dosym dnf-${python_major} /usr/bin/dnf
	mv "${ED}"/usr/bin/dnf-automatic-${python_major} "${ED}"/usr/bin/dnf-automatic
	rm -f "${ED}"/usr/bin/dnf-automatic-*

	dosym dnf /usr/bin/yum

	dodir /var/lib/dnf/{history,yumdb}
	dodir /var/log/dnf
	touch "${ED}"/var/log/dnf/dnf.log
	touch "${ED}"/var/log/{hawkey.log,dnf.librepo.log,dnf.rpm.log,dnf.plugin.log}

	einfo "Cleaning up locales..."
	for lang in ${LANGS[@]}; do
		use "l10n_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${ED}"/usr/share/locale/${lang} || die
	done
	rm -Rf "${ED}"/usr/share/locale/{bn_IN,en_GB,fur,pt_BR,sr@latin,ur,zh_CN,zh_TW}

	# remove locale directory when empty
	rmdir "${ED}"/usr/share/locale 2>/dev/null
}
