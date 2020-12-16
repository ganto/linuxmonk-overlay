# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit acct-user

DESCRIPTION="user for matrix-synapse"
ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( matrix-synapse )
ACCT_USER_HOME=/var/lib/matrix-synapse
ACCT_USER_HOME_PERMS=0750

acct-user_add_deps
