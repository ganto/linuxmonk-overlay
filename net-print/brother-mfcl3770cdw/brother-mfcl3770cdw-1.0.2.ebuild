# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="Printer driver for Brother MFC-L3770CDW"
HOMEPAGE="https://brother.com"
SRC_URI="https://download.brother.com/welcome/dlf103949/mfcl3770cdwpdrv-${PV}-0.i386.rpm"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	net-print/cups
"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	dobin usr/bin/brprintconf_mfcl3770cdw

	dodir /opt/brother/Printers/mfcl3770cdw

	exeinto /opt/brother/Printers/mfcl3770cdw/cupswrapper
	doexe opt/brother/Printers/mfcl3770cdw/cupswrapper/{brother_lpdwrapper_mfcl3770cdw,cupswrappermfcl3770cdw}

	exeinto /opt/brother/Printers/mfcl3770cdw/lpd
	doexe opt/brother/Printers/mfcl3770cdw/lpd/{brmfcl3770cdwfilter,filter_mfcl3770cdw}

	insinto /opt/brother/Printers/mfcl3770cdw/inf
	doins -r opt/brother/Printers/mfcl3770cdw/inf/.

	exeinto /opt/brother/Printers/mfcl3770cdw/inf
	doexe opt/brother/Printers/mfcl3770cdw/inf/setupPrintcapij

	insinto /usr/share/ppd/Brother
	doins opt/brother/Printers/mfcl3770cdw/cupswrapper/brother_mfcl3770cdw_printer_en.ppd

	# relative symlink will break printing
	dosym /opt/brother/Printers/mfcl3770cdw/cupswrapper/brother_lpdwrapper_mfcl3770cdw \
		/usr/libexec/cups/filter/brother_lpdwrapper_mfcl3770cdw
}
