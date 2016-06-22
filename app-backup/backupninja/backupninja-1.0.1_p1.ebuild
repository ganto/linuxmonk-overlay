# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

MY_PV=${PV/_p*}
MY_P=${PN}-${MY_PV}

# This thing change with every release, how idiotic...
NODE_NUMBER=275

DESCRIPTION="lightweight, extensible meta-backup system"
HOMEPAGE="https://labs.riseup.net/code/projects/backupninja"
SRC_URI="https://labs.riseup.net/code/attachments/download/${NODE_NUMBER}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-util/dialog"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS FAQ TODO README NEWS )

S=${WORKDIR}/${MY_P}

src_prepare() {
	# official patches from upstream git
	epatch "${FILESDIR}/${MY_P}-1790b533-Duplicity-for-local-backups-check-that-dest-dir-exists.patch"
	epatch "${FILESDIR}/${MY_P}-625d1424-xz-support-for-tar-handler.patch"
	epatch "${FILESDIR}/${MY_P}-4ebee050-Test-mode-support-for-tar-handler.patch"
	epatch "${FILESDIR}/${MY_P}-0df3c993-Fix-luks-header-backup-to-properly-detect-partitions.patch"
	epatch "${FILESDIR}/${MY_P}-54ec07be-Add-additional-sys-backup-option.patch"
	epatch "${FILESDIR}/${MY_P}-b8b8b46f-Solve-quoting-issues-with-su.patch"
	epatch "${FILESDIR}/${MY_P}-29e2c75e-mysql-make-nodata-option-with-compress-no.patch"
	epatch "${FILESDIR}/${MY_P}-3c19ee1f-Update-ChangeLog.patch"
	epatch "${FILESDIR}/${MY_P}-e96a894b-mysql-fix-non-qualified-table-name-extraction.patch"
	epatch "${FILESDIR}/${MY_P}-e27654df-Dont-remove-useful-signature-files.patch"
	epatch "${FILESDIR}/${MY_P}-1a762885-Make-logic-consistent-with-what-were-using-elsewhere.patch"
	epatch "${FILESDIR}/${MY_P}-0e6df840-Add-shell-functions-to-compare-version-numbers.patch"
	epatch "${FILESDIR}/${MY_P}-1017ec31-dup-fix-buggy-version-comparison.patch"
	epatch "${FILESDIR}/${MY_P}-c5738b11-Added-SIGN_PASSPHRASE-support-for-dup-handler.patch"
	epatch "${FILESDIR}/${MY_P}-ed864a64-Run-duplicity-in-C-locales-environment.patch"
	epatch "${FILESDIR}/${MY_P}-7c70c834-Force-rsync-handler-run-bash-at-the-remote-destination.patch"
	epatch "${FILESDIR}/${MY_P}-48134276-Update-increment-folder-date.patch"
	epatch "${FILESDIR}/${MY_P}-5bc3e60a-Rsync-restoring-IFS-noglob.patch"
	epatch "${FILESDIR}/${MY_P}-03292147-Rsync-example-show-user-parameter-as-a-required-option.patch"
	epatch "${FILESDIR}/${MY_P}-8ed2f8de-Add-suse-to-the-list-of-supported-OS.patch"
	epatch "${FILESDIR}/${MY_P}-14eed7f7-Remove-spurious-quotes-that-broke-the-sys-helper.patch"
	epatch "${FILESDIR}/${MY_P}-8db80421-Fix-indentation-in-sys-handler.patch"
	epatch "${FILESDIR}/${MY_P}-9b37f756-Exclude-tmpfs-from-df-output-in-sys-handler.patch"
	epatch "${FILESDIR}/${MY_P}-21bcb7e6-Ignore-files-ending-in-tilde.patch"
	epatch "${FILESDIR}/${MY_P}-c649339b-Rsync-support-for-backupninjas-test-option.patch"
	epatch "${FILESDIR}/${MY_P}-89860aa3-Rsync-check-test-mode-also-in-prepare_storage.patch"
	epatch "${FILESDIR}/${MY_P}-3094b04d-Rsync-check-test-mode-should-set-proper-dest-path.patch"
	epatch "${FILESDIR}/${MY_P}-sys-Add-support-for-Gentoo.patch"
	epatch "${FILESDIR}/${MY_P}-sys-Don-t-try-to-investigate-ram-disks.patch"

	if ${AUTOCONF_VERSION} > 2.13; then
		mv configure.in configure.ac
	fi
	eautoreconf
}
