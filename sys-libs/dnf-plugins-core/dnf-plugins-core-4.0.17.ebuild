# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake python-single-r1

DESCRIPTION="Core DNF plugins"
HOMEPAGE="https://github.com/rpm-software-management/dnf-plugins-core"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="${PYTHON_DEPS}"
RDEPEND="${CDEPEND}
	>=sys-apps/dnf-4.2.1[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		sys-libs/libdnf[${PYTHON_MULTI_USEDEP}]
	')
"
DEPEND="${CDEPEND}
	dev-python/sphinx
	sys-devel/gettext
	test? ( dev-python/nose )
"

LANGS=( ca cs da de es eu fi fr hu it id ja ko nl pa pl pt ru sq sr sv tr uk )

for X in "${LANGS[@]}" ; do
	IUSE+=" l10n_${X}"
done
unset X

src_prepare() {
	cmake_src_prepare
	sed -i 's/sphinx-build-3/sphinx-build/' doc/CMakeLists.txt
}

src_configure() {
	mycmakeargs=( -DPYTHON_DESIRED:str=3 )
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	cmake_src_compile doc-man
}

src_test() {
	PYTHONPATH="${BUILD_DIR}/plugins" nosetests -s tests || die "tests failed"
}

src_install() {
	cmake_src_install

	mv "${ED}"/usr/libexec/dnf-utils-3 "${ED}"/usr/libexec/dnf-utils

	python_setup
	python_optimize "${ED}"/$(python_get_sitedir)
	sed -i "1c#!/usr/bin/${EPYTHON}" "${ED}"/usr/libexec/dnf-utils

	for util in debuginfo-install dnf-utils find-repos-of-install \
			needs-restarting package-cleanup repo-graph repoclosure \
			repodiff repomanage repoquery reposync repotrack yum-builddep \
			yum-config-manager yum-debug-dump yum-debug-restore \
			yumdownloader; do
		dosym ../libexec/dnf-utils /usr/bin/${util}
	done

	# These commands don't have a dedicated man page, so let's just point them
	# to the utils page which contains their descriptions.
	for util in find-repos-of-install repoquery repotrack; do
		dosym dnf-utils.1 /usr/share/man/man1/${util}.1
	done

	# cleanup leaked build files
	rm -Rf "${ED}"/usr/share/man/man8/{CMakeFiles,.doctrees}

	einfo "Cleaning up locales..."
	for lang in ${LANGS[@]}; do
		use "l10n_${lang}" && {
			einfo "- keeping ${lang}"
			continue
		}
		rm -Rf "${ED}"/usr/share/locale/${lang} || die
	done
	rm -Rf "${ED}"/usr/share/locale/{fur,pt_BR,zh_CN,zh_TW}

	# remove locale directory when empty
	rmdir "${ED}"/usr/share/locale 2>/dev/null
}

pkg_postinst() {
	elog "dnf-plugins-core includes a number of plugins which might need"
	elog "additional runtime dependencies:"
	elog "  local:   app-arch/createrepo_c"
}
