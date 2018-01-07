# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils python-r1

DESCRIPTION="Core DNF plugins"
HOMEPAGE="https://github.com/rpm-software-management/dnf-plugins-core"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

CDEPEND="${PYTHON_DEPS}"
RDEPEND="${CDEPEND}
	>=sys-apps/dnf-2.7.0[${PYTHON_USEDEP}]
	sys-libs/libdnf[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}
	dev-python/sphinx
	sys-devel/gettext
	test? ( dev-python/nose )
"

LANGS=( ca cs da de es eu fi fr hu it ja pl ru sq sr sv uk )

for X in "${LANGS[@]}" ; do
	IUSE+=" l10n_${X}"
done
unset X

src_prepare() {
    cmake-utils_src_prepare
    python_copy_sources
}

src_configure() {
	dnf_plugins_core_src_configure_internal() {
		local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )
		mycmakeargs=( -DPYTHON_DESIRED:str=${python_major} )

		cmake-utils_src_configure
	}
	python_foreach_impl dnf_plugins_core_src_configure_internal
}

src_compile() {
	dnf_plugins_core_src_compile_internal() {
		cmake-utils_src_compile
		cmake-utils_src_compile doc-man
	}
	python_foreach_impl dnf_plugins_core_src_compile_internal
}

src_test() {
	dnf_plugins_core_src_test() {
		PYTHONPATH="${BUILD_DIR}/plugins" nosetests -s tests || die "tests failed with ${EPYTHON}"
	}
	python_foreach_impl dnf_plugins_core_src_test
}

src_install() {
	python_foreach_impl cmake-utils_src_install

	dnf_plugins_core_src_install_optimize() {
		python_optimize "${ED}"/$(python_get_sitedir)
	}
	python_foreach_impl dnf_plugins_core_src_install_optimize

	python_setup
	local python_major=$( cut -d'.' -f1 <<< "${EPYTHON/python/}" )

	dosym dnf-utils-${python_major} /usr/bin/dnf-utils
	for util in debuginfo-install find-repos-of-install repo-graph \
			package-cleanup repoclosure repomanage repoquery reposync repotrack \
			yum-builddep yum-config-manager yum-debug-dump yum-debug-restore \
			yumdownloader; do
		dosym dnf-utils /usr/bin/${util}
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
	rm -Rf "${ED}"/usr/share/locale/{pt_BR,zh_CN,zh_TW}

	# remove locale directory when empty
	rmdir "${ED}"/usr/share/locale 2>/dev/null
}

pkg_postinst() {
	elog "dnf-plugins-core includes a number of plugins which might need"
	elog "additional runtime dependencies:"
	elog "  local:   app-arch/createrepo_c"
}
