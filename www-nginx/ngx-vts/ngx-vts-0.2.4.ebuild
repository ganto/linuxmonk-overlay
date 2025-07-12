# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="nginx-module-vts"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="NGINX virtual host traffic status module"
HOMEPAGE="https://github.com/vozlt/nginx-module-vts"
SRC_URI="https://github.com/vozlt/nginx-module-vts/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=www-servers/nginx[nginx_modules_http_stub_status]
