# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod

MY_PN="CoreFreq"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Kernel module for sys-apps/corefreq"
HOMEPAGE="https://github.com/cyring/CoreFreq"
SRC_URI="https://github.com/cyring/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${MY_P}.gh.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!<sys-apps/corefreq-${PV}[modules]"

CONFIG_CHECK="~MODULES ~SMP ~X86_MSR"

PATCHES=(
	"${FILESDIR}"/"${PV}"-Add-separate-target-to-build-kernel-module.patch
	"${FILESDIR}"/"${PV}"-Fixed-conditional-build-linked-to-CONFIG_PM_SLEEP.patch
)

S="${WORKDIR}/${MY_P}"

BUILD_TARGETS="module"
MODULE_NAMES="corefreqk(extra:${S}:${S})"

pkg_pretend() {
	linux-mod_pkg_setup
}

pkg_setup() {
	linux-mod_pkg_setup
}

src_compile() {
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}
