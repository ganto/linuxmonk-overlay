# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Grub2 theme icons for various operating systems"
HOMEPAGE="https://github.com/CMoH/grub2-theme-gentoo"

EGIT_REPO_URI="https://github.com/CMoH/grub2-theme-gentoo.git"

if [[ ${PV} != 9999* ]] ; then
	EGIT_COMMIT="v${PV}"
fi

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"   # unsure what to place here
SLOT="0"
IUSE=""

RDEPEND="sys-boot/grub:2"

src_install() {
	dodir /boot/grub/themes/icons/ || die

	insinto /boot/grub/themes/icons/
	doins icons/*.png
}
