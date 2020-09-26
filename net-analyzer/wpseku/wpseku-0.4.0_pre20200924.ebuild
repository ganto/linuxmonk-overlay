# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1 eutils

GIT_COMMIT=862fb2c2fe7f3ebfd83aab3c395789f616391157
MY_PN="WPSeku"
MY_P="${MY_PN}-${GIT_COMMIT}"

DESCRIPTION="Black box WordPress vulnerability scanner"
HOMEPAGE="https://github.com/m4ll0k/WPSeku"
SRC_URI="https://github.com/m4ll0k/${MY_PN}/archive/${GIT_COMMIT}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/humanfriendly[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/0.4.0-Add-setup.py-packaging.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Fix DOS line endings
	rm -rf screen/
	grep -rlZ $'\r$' . |
	while read -r -d $'\0' file ; do
		edos2unix "${file}"
	done
}
