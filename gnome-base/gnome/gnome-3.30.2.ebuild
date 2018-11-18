# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Meta package for GNOME 3, merge this package to install"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="2.0" # Cannot be installed at the same time as gnome-2

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64"

IUSE="+bluetooth +classic +cdr cups +extras"

S=${WORKDIR}

RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]
	>=gnome-base/gnome-core-apps-${PV}[cups?,bluetooth?,cdr?]

	>=gnome-base/gdm-3.30.1

	>=x11-wm/mutter-3.30.1
	>=gnome-base/gnome-shell-3.30.1[bluetooth?]

	>=x11-themes/gnome-backgrounds-3.30.0
	x11-themes/sound-theme-freedesktop

	classic? ( >=gnome-extra/gnome-shell-extensions-3.30.1 )
	extras? ( >=gnome-base/gnome-extra-apps-${PV} )
"

DEPEND=""

PDEPEND=">=gnome-base/gvfs-1.38.1[udisks]"

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
