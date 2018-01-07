# Copyright 1999-2018 Gentoo Foundation
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
IUSE="test"

CDEPEND="${PYTHON_DEPS}"
RDEPEND="${CDEPEND}
	>=sys-apps/dnf-1.1.9[${PYTHON_USEDEP}]
	<=sys-apps/dnf-2.0[${PYTHON_USEDEP}]
	sys-libs/hawkey[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}
	dev-python/sphinx
	sys-devel/gettext
	test? ( dev-python/nose )
"

PATCHES=(
	"${FILESDIR}"/${P}-0000-cls.chroot_config-inside-_guess_chroot-returns-None.patch
	"${FILESDIR}"/${P}-0001-builddep-install-requirements-by-provides-RhBug-1332.patch
	"${FILESDIR}"/${P}-0002-builddep-install-by-files-as-well.patch
	"${FILESDIR}"/${P}-0003-builddep-show-message-if-package-is-already-installe.patch
	"${FILESDIR}"/${P}-0004-tests-remove-builddep-test.patch
	"${FILESDIR}"/${P}-0005-builddep-always-try-to-install-by-provides.patch
)

S="${WORKDIR}/dnf-plugins-core-${P}-2"

LANGS=( ca da de es eu fr hu it ja pl sr uk )

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
		mycmakeargs=( -DPYTHON_DESIRED=${python_major} )

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
