# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="ngx_http_auth_pam_module"
NGINX_MOD_S="${WORKDIR}/${MY_PN}-${PV}"

inherit nginx-module

DESCRIPTION="NGINX module to use PAM for simple http authentication"
HOMEPAGE="https://github.com/sto/ngx_http_auth_pam_module"
SRC_URI="https://github.com/sto/ngx_http_auth_pam_module/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
