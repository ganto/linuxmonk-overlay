# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit pam python-single-r1 bash-completion-r1

MY_PV=${PV}-1
MY_P=${PN}-${MY_PV}
CORE_CONFIGS_VERSION=42.3-1

DESCRIPTION="Builds RPM packages inside chroots"
HOMEPAGE="
	https://rpm-software-management.github.io/mock/
	https://github.com/rpm-software-management/mock/
"
SRC_URI="
	https://github.com/rpm-software-management/${PN}/archive/${MY_P}.tar.gz
	https://github.com/rpm-software-management/${PN}/archive/${PN}-core-configs-${CORE_CONFIGS_VERSION}.tar.gz
"
S="${WORKDIR}/mock-${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="
	mirror
	!test? ( test )
"

RDEPEND="
	${PYTHON_DEPS}
	acct-group/mock acct-user/mock
	app-arch/createrepo_c
	app-arch/pigz
	app-arch/rpm[python,${PYTHON_SINGLE_USEDEP},zstd(+)]
	$(python_gen_cond_dep '
		dev-python/backoff[${PYTHON_USEDEP}]
		dev-python/distro[${PYTHON_USEDEP}]
		dev-python/jinja2[${PYTHON_USEDEP}]
		dev-python/pyroute2[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/rpmautospec-core[${PYTHON_USEDEP}]
		>=dev-python/templated-dictionary-1.5[${PYTHON_USEDEP}]
	')
	>=dev-util/distribution-gpg-keys-1.111
	sys-apps/iproute2
	sys-apps/shadow
	sys-apps/usermode
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/argparse-manpage[${PYTHON_USEDEP}]')
	test? ( $(python_gen_cond_dep '
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	') )
"

PATCHES=(
	"${FILESDIR}"/4.0-Adjust-CLI-tools-default-path.patch
)

src_prepare() {
	default

	pushd mock >/dev/null || die
	sed -i -e "s|^_MOCK_NVR = None$|_MOCK_NVR = \"${MY_P}\"|" py/mock.py
	for i in py/mockbuild/constants.py py/mock-parse-buildlog.py; do
		sed -i -e "s|^VERSION\s*=.*|VERSION=\"${PV}\"|" ${i}
		sed -i -e "s|^SYSCONFDIR\s*=.*|SYSCONFDIR=\"/etc\"|" ${i}
		sed -i -e "s|^PYTHONDIR\s*=.*|PYTHONDIR=\"$(python_get_sitedir)\"|" ${i}
		sed -i -e "s|^PKGPYTHONDIR\s*=.*|PKGPYTHONDIR=\"$(python_get_sitedir)/mockbuild\"|" ${i}
	done
	for i in docs/mock.1 docs/mock-parse-buildlog.1; do
		sed -i -e "s|@VERSION@|${PV}\"|" ${i}
	done

	# Gentoo doesn't know /etc/pki
	sed -i -e "s|/etc/pki/mock|/etc/ssl/mock|g" etc/mock/*
	popd >/dev/null
}

src_compile() {
	pushd mock >/dev/null || die
	# TODO: this fails when being executed through portage
	#./precompile-bash-completion "mock.complete" || die "Failed to generate bash-completion"
	cp "${FILESDIR}/mock-${PV}.complete" mock.complete
	argparse-manpage --pyfile py/mock-hermetic-repo.py --function _argparser > mock-hermetic-repo.1 || die
	popd >/dev/null
}

src_install() {
	pushd mock >/dev/null || die
	python_scriptinto /usr/bin
	python_newscript py/mock-hermetic-repo.py mock-hermetic-repo
	python_newscript py/mock-parse-buildlog.py mock-parse-buildlog
	dobin mockchain

	python_scriptinto /usr/libexec/mock
	python_newscript py/mock.py mock

	dosym consolehelper /usr/bin/mock

	dopamd etc/pam/*

	insinto /etc/mock
	doins etc/mock/*

	insinto /etc/security/console.apps
	doins etc/consolehelper/mock

	insinto /etc/ssl/mock
	doins etc/pki/*

	python_domodule py/mockbuild

	doman docs/mock.1 docs/mock-parse-buildlog.1 mock-hermetic-repo.1
	dodoc README.md docs/site-defaults.cfg docs/buildroot-lock-schema-*.json

	insinto /usr/share/cheat
	newins docs/mock.cheat mock

	diropts -m 0775 -g mock
	dodir /var/lib/mock /var/cache/mock
	keepdir /var/lib/mock /var/cache/mock

	newbashcomp mock.complete mock
	bashcomp_alias mock mock.py
	bashcomp_alias mock mock-parse-buildlog
	bashcomp_alias mock mock-parse-buildlog.py
	popd >/dev/null

	pushd ../mock-mock-core-configs-${CORE_CONFIGS_VERSION}/mock-core-configs >/dev/null || die
	insinto /etc/mock
	doins -r etc/mock/*
	popd >/dev/null
}

pkg_postinst() {
	elog
	elog "Mock includes a number of plugins which might need additional runtime"
	elog "dependencies:"
	elog "  nspawn:          sys-apps/systemd"
	elog "  bootstrap_image: app-emulation/libpod"
	elog "  ccache:          dev-util/ccache"
	elog "  compress_logs:   app-arch/xz-utils"
	elog "  lvm_root:        sys-fs/lvm2"
	elog "  scm:             dev-vcs/git"
	elog "                   dev-vcs/subversion"
	elog "                   dev-vcs/cvs"
	elog "  rpmautospec:     dev-python/rpmautospec-core"
	elog "  hwinfo:          sys-apps/util-linux"
	elog "                   sys-apps/coreutils"
	elog "                   sys-process/procps"
	elog "  procenv:         sys-process/procenv"
	elog
	elog "To use mock as a non-root user, add yourself to the 'mock' group:"
	elog "  usermod -aG mock youruser"
	elog
}

src_test() {
	pushd mock >/dev/null || die
	PYTHONPATH=py epytest tests
	popd >/dev/null
}
