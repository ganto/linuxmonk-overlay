# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake-utils python-single-r1 bash-completion-r1

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
	>=app-arch/rpm-4.14.0[python,${PYTHON_SINGLE_USEDEP}]
	dev-db/sqlite
	>=sys-libs/libmodulemd-1.4.0:0

	$(python_gen_cond_dep '
		>=app-crypt/gpgme-1.10.0[python,${PYTHON_MULTI_USEDEP}]
		>=dev-libs/libcomps-0.1.8[${PYTHON_MULTI_USEDEP}]
		dev-python/iniparse[${PYTHON_MULTI_USEDEP}]
		>=sys-libs/libdnf-0.46.2[${PYTHON_MULTI_USEDEP}]
		>=sys-libs/librepo-1.7.19[${PYTHON_MULTI_USEDEP}]
	')
	$(python_gen_cond_dep 'dev-python/pyliblzma[${PYTHON_MULTI_USEDEP}]' python2_7)
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

PATCHES=( "${FILESDIR}"/4.2.6-Always-use-sphinx-build.patch )

LANGS=(
	ar bg ca cs da de el eo es eu fa fi fil fr gd gu he hi hr hu id it ja ka kk ko
	lt ml mr ms nb nl or pa pl pt ru sk sq sr sv th tr uk ur
)

for X in "${LANGS[@]}" ; do
	IUSE+=" l10n_${X}"
done
unset X

src_configure() {
	mycmakeargs=( -DPYTHON_DESIRED:str=3 -Wno-dev )
	cmake-utils_src_configure
}

src_compile() {
	# make sure we get a processed const.py
	cp -p "${S}"/dnf/const.py "${BUILD_DIR}"/dnf

	cmake-utils_src_compile
	cmake-utils_src_compile doc-man

	# fix shebang of temporary build python path
	python_setup
	sed -i "1 s|^.*$|#!${PYTHON}|" "${S}"/bin/*-3
}

src_test() {
	python_setup
	DESTDIR="${WORKDIR}-test-${EPYTHON}" cmake-utils_src_make install
	PYTHONPATH="${WORKDIR}-test-${EPYTHON}"/$(python_get_sitedir) nosetests -s tests || die "tests failed with ${EPYTHON}"
}

src_install() {
	cmake-utils_src_install
	python_optimize "${ED}"/$(python_get_sitedir)

	mv "${ED}"/usr/bin/dnf-3 "${ED}"/usr/bin/dnf
	mv "${ED}"/usr/bin/dnf-automatic-3 "${ED}"/usr/bin/dnf-automatic

	dosym dnf /usr/bin/yum

	keepdir /var/lib/dnf/{history,yumdb}
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
	rm -Rf "${ED}"/usr/share/locale/{bn_IN,en_GB,fur,pt_BR,sr@latin,zh_CN,zh_TW}

	# remove locale directory when empty
	rmdir "${ED}"/usr/share/locale 2>/dev/null
}
