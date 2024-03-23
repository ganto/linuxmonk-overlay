# Copyright 2021-2024 Gentoo Authors
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
	"github.com/BurntSushi/toml v1.3.2/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.2"
	"github.com/cpuguy83/go-md2man/v2 v2.0.2/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/russross/blackfriday/v2 v2.1.0"
	"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.4.0/go.mod"
	"github.com/stretchr/objx v0.5.0/go.mod"
	"github.com/stretchr/testify v1.7.1/go.mod"
	"github.com/stretchr/testify v1.8.0/go.mod"
	"github.com/stretchr/testify v1.8.4"
	"github.com/stretchr/testify v1.8.4/go.mod"
	"github.com/urfave/cli v1.22.14"
	"github.com/urfave/cli v1.22.14/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.4.0/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
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
