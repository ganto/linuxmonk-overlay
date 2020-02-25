# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit python-single-r1 bash-completion-r1

CORE_CONFIGS_VERSION=32.3-2

DESCRIPTION="Builds RPM packages inside chroots"
HOMEPAGE="https://github.com/rpm-software-management/mock"
SRC_URI="https://github.com/rpm-software-management/${PN}/archive/${P}-2.tar.gz
	https://github.com/rpm-software-management/${PN}/archive/${PN}-core-configs-${CORE_CONFIGS_VERSION}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	acct-group/mock acct-user/mock
	app-arch/createrepo_c
	app-arch/pigz
	app-arch/rpm[lua,python,${PYTHON_SINGLE_USEDEP},zstd]
	>=app-misc/distribution-gpg-keys-1.36
	$(python_gen_cond_dep '
		dev-python/distro[${PYTHON_MULTI_USEDEP}]
		dev-python/jinja[${PYTHON_MULTI_USEDEP}]
		dev-python/pyroute2[${PYTHON_MULTI_USEDEP}]
		dev-python/requests[${PYTHON_MULTI_USEDEP}]
	')
	sys-apps/iproute2
	sys-apps/usermode
	sys-apps/dnf
	sys-libs/dnf-plugins-core
"

PATCHES=(
	"${FILESDIR}"/1.4.19-Fix-path.patch
)

S="${WORKDIR}/mock-${P}-2"

src_compile() {
	pushd mock
	for i in py/mock.py py/mock-parse-buildlog.py; do
		sed -i -e "s|^__VERSION__\s*=.*|__VERSION__=\"${PV}\"|" ${i}
		sed -i -e "s|^SYSCONFDIR\s*=.*|SYSCONFDIR=\"/etc\"|" ${i}
		sed -i -e "s|^PYTHONDIR\s*=.*|PYTHONDIR=\"$(python_get_sitedir)\"|" ${i}
		sed -i -e "s|^PKGPYTHONDIR\s*=.*|PKGPYTHONDIR=\"$(python_get_sitedir)/mockbuild\"|" ${i}
	done
	for i in docs/mock.1 docs/mock-parse-buildlog.1; do
		sed -i -e "s|@VERSION@|${PV}\"|" ${i}
	done

	# Gentoo doesn't know /etc/pki
	sed -i -e "s|/etc/pki/mock|/etc/ssl/mock|g" etc/mock/*
	popd
}

src_install() {
	pushd mock
	python_scriptinto /usr/bin
	python_newscript py/mock-parse-buildlog.py mock-parse-buildlog
	dobin mockchain

	python_scriptinto /usr/libexec/mock
	python_newscript py/mock.py mock

	dosym consolehelper /usr/bin/mock

	exeinto /usr/libexec/mock
	doexe create_default_route_in_container.sh

	insinto /etc/pam.d
	doins etc/pam/*

	insinto /etc/mock
	doins etc/mock/*

	insinto /etc/security/console.apps
	doins etc/consolehelper/mock

	insinto /etc/ssl/mock
	doins etc/pki/*

	python_domodule py/mockbuild

	doman docs/mock.1 docs/mock-parse-buildlog.1

	insinto /usr/share/cheat
	newins docs/mock.cheat mock

	install -d -m 2775 -g mock "${EROOT%/}/var/lib/mock"
	install -d -m 2775 -g mock "${EROOT%/}/var/cache/mock"
	keepdir /var/lib/mock /var/cache/mock

	dobashcomp etc/bash_completion.d/mock
	bashcomp_alias mock mock.py
	bashcomp_alias mock mock-parse-buildlog
	popd

	pushd ../mock-mock-core-configs-${CORE_CONFIGS_VERSION}/mock-core-configs
	insinto /etc/mock
	doins -r etc/mock/*
	popd
}

pkg_postinst() {
	elog
	elog "Mock includes a number of plugins which might need additional runtime"
	elog "dependencies:"
	elog "  nspawn:          sys-apps/systemd"
	elog "  bootstrap_image  app-emulation/libpod"
	elog "  ccache           dev-util/ccache"
	elog "  compress_logs    app-arch/xz-utils"
	elog "  lvm_root         sys-fs/lvm2"
	elog "  scm:             dev-vcs/git"
	elog "                   dev-vcs/subversion"
	elog "                   dev-vcs/cvs"
	elog "  hwinfo:          sys-apps/util-linux"
	elog "                   sys-apps/coreutils"
	elog "                   sys-process/procps"
	elog "  procenv:         sys-process/procenv"
	elog
	elog "To use mock as a non-root user, add yourself to the 'mock' group:"
	elog "  usermod -aG mock youruser"
	elog
}
