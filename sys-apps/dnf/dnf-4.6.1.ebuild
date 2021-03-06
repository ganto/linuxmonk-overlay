# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake python-single-r1 bash-completion-r1

DESCRIPTION="DNF is a package manager based on yum and libsolv"
HOMEPAGE="https://github.com/rpm-software-management/dnf"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

LANGS=(
	ar bg bn-IN ca cs da de el en-GB eo es eu fa fi fil fr gd gu he hi hr hu id it ja ka kk ko
	lt ml mr ms nb nl or pa pl pt pt-BR ru sk sq sr sv th tr uk ur vi zh-CN zh-TW
)
# localized help versions are installed only, when L10N var is set
for i in "${LANGS[@]}" ; do
	IUSE="${IUSE} l10n_${i}"
done

# the upstream app-arch/rpm uses python-single-r1 eclass and only supports one
# python implementation, don't restrict ourselves and support multiple python
# implementations in case rpm will ever switch to python-r1 eclass
DEPEND="
	>=app-arch/rpm-4.14.0[python,${PYTHON_SINGLE_USEDEP}]
	dev-db/sqlite
	>=sys-libs/libmodulemd-2.9.3:2

	$(python_gen_cond_dep '
		>=app-crypt/gpgme-1.10.0[python,${PYTHON_MULTI_USEDEP}]
		>=dev-libs/libcomps-0.1.8[${PYTHON_MULTI_USEDEP}]
		dev-python/iniparse[${PYTHON_MULTI_USEDEP}]
		>=sys-libs/libdnf-0.54.1[${PYTHON_MULTI_USEDEP}]
	')
	$(python_gen_cond_dep 'dev-python/pyliblzma[${PYTHON_MULTI_USEDEP}]' python2_7)
"
RDEPEND="${DEPEND}
	!!sys-apps/yum
	!<=sys-libs/dnf-plugins-core-4.0.16
"
BDEPEND="
	${PYTHON_DEPS}
	dev-python/sphinx
	sys-devel/gettext
	test? (
		${RDEPEND}
		dev-python/nose
	)
"

PATCHES=( "${FILESDIR}"/4.2.6-Always-use-sphinx-build.patch )

src_configure() {
	mycmakeargs=( -DPYTHON_DESIRED:str=3 -Wno-dev )
	cmake_src_configure
}

src_compile() {
	# make sure we get a processed const.py
	cp -p "${S}"/dnf/const.py "${BUILD_DIR}"/dnf

	cmake_src_compile
	cmake_src_compile doc-man

	# fix shebang of temporary build python path
	python_setup
	sed -i "1 s|^.*$|#!${PYTHON}|" "${S}"/bin/*-3
}

src_test() {
	python_setup
	DESTDIR="${WORKDIR}-test-${EPYTHON}" cmake_src_install
	PYTHONPATH="${WORKDIR}-test-${EPYTHON}"/$(python_get_sitedir) nosetests -s tests || die "tests failed with ${EPYTHON}"
}

src_install() {
	cmake_src_install
	python_optimize "${ED}"/$(python_get_sitedir)

	mv "${ED}"/usr/bin/dnf-3 "${ED}"/usr/bin/dnf
	mv "${ED}"/usr/bin/dnf-automatic-3 "${ED}"/usr/bin/dnf-automatic

	dosym dnf /usr/bin/yum

	keepdir /var/lib/dnf/{history,yumdb}
	dodir /var/log/dnf
	touch "${ED}"/var/log/dnf/dnf.log
	touch "${ED}"/var/log/{hawkey.log,dnf.librepo.log,dnf.rpm.log,dnf.plugin.log}

	# clean unneeded language documentation
	rm -rf "${ED}"/usr/share/locale/{fur,sr@latin}
	for i in ${LANGS[@]}; do
		use l10n_${i} || rm -rf "${ED}"/usr/share/locale/${i/-/_}
	done

	# remove locale directory when empty
	rmdir "${ED}"/usr/share/locale 2>/dev/null
}
