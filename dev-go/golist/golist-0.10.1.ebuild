# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="A tool to analyse the properties of a Go (Golang) codebase"
HOMEPAGE="https://pagure.io/golist"

# generate with:
#   go mod init pagure.io/golist
#   go mod tidy
#   cat go.sum | cut -d' ' -f1,2 | sed -e 's/^/\t"/g' -e 's/$/"/g'
EGO_SUM=(
	"github.com/BurntSushi/toml v0.3.1/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d"
	"github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/russross/blackfriday/v2 v2.0.1"
	"github.com/russross/blackfriday/v2 v2.0.1/go.mod"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0"
	"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
	"github.com/urfave/cli v1.22.5"
	"github.com/urfave/cli v1.22.5/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
)

go-module_set_globals

SRC_URI="https://pagure.io/${PN}/archive/v${PV}/${PN}-v${PV}.tar.gz
	${EGO_SUM_SRC_URI}"
RESTRICT="mirror strip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/go:="

DOCS=( README.md NEWS.md )

S="${WORKDIR}/${PN}-v${PV}"

src_unpack() {
	mkdir "${S}"
	cp "${FILESDIR}/${PV}-go.mod" "${S}"/go.mod || die
	cp "${FILESDIR}/${PV}-go.sum" "${S}"/go.sum || die

	go-module_src_unpack
}

src_compile() {
	mkdir build || die
	go build -v -x -o build ./... || die "go build failed"
}

src_install() {
	dobin build/"${PN}"
	einstalldocs
}
