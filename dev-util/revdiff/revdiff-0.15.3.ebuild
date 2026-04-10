# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

DESCRIPTION="TUI for reviewing diffs, files, and documents with inline annotations"
HOMEPAGE="https://github.com/umputun/revdiff"

# generated with: cat go.sum | cut -d' ' -f1,2 | sed -e 's/^/\t"/g' -e 's/$/"/g'
EGO_SUM=(
	"github.com/alecthomas/assert/v2 v2.11.0"
	"github.com/alecthomas/assert/v2 v2.11.0/go.mod"
	"github.com/alecthomas/chroma/v2 v2.23.1"
	"github.com/alecthomas/chroma/v2 v2.23.1/go.mod"
	"github.com/alecthomas/repr v0.5.2"
	"github.com/alecthomas/repr v0.5.2/go.mod"
	"github.com/atotto/clipboard v0.1.4"
	"github.com/atotto/clipboard v0.1.4/go.mod"
	"github.com/aymanbagabas/go-osc52/v2 v2.0.1"
	"github.com/aymanbagabas/go-osc52/v2 v2.0.1/go.mod"
	"github.com/charmbracelet/bubbles v1.0.0"
	"github.com/charmbracelet/bubbles v1.0.0/go.mod"
	"github.com/charmbracelet/bubbletea v1.3.10"
	"github.com/charmbracelet/bubbletea v1.3.10/go.mod"
	"github.com/charmbracelet/colorprofile v0.4.3"
	"github.com/charmbracelet/colorprofile v0.4.3/go.mod"
	"github.com/charmbracelet/lipgloss v1.1.0"
	"github.com/charmbracelet/lipgloss v1.1.0/go.mod"
	"github.com/charmbracelet/x/ansi v0.11.6"
	"github.com/charmbracelet/x/ansi v0.11.6/go.mod"
	"github.com/charmbracelet/x/cellbuf v0.0.15"
	"github.com/charmbracelet/x/cellbuf v0.0.15/go.mod"
	"github.com/charmbracelet/x/term v0.2.2"
	"github.com/charmbracelet/x/term v0.2.2/go.mod"
	"github.com/clipperhouse/displaywidth v0.11.0"
	"github.com/clipperhouse/displaywidth v0.11.0/go.mod"
	"github.com/clipperhouse/uax29/v2 v2.7.0"
	"github.com/clipperhouse/uax29/v2 v2.7.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/dlclark/regexp2 v1.11.5"
	"github.com/dlclark/regexp2 v1.11.5/go.mod"
	"github.com/erikgeiser/coninput v0.0.0-20211004153227-1c3628e74d0f"
	"github.com/erikgeiser/coninput v0.0.0-20211004153227-1c3628e74d0f/go.mod"
	"github.com/hexops/gotextdiff v1.0.3"
	"github.com/hexops/gotextdiff v1.0.3/go.mod"
	"github.com/jessevdk/go-flags v1.6.1"
	"github.com/jessevdk/go-flags v1.6.1/go.mod"
	"github.com/lucasb-eyer/go-colorful v1.4.0"
	"github.com/lucasb-eyer/go-colorful v1.4.0/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"github.com/mattn/go-localereader v0.0.1"
	"github.com/mattn/go-localereader v0.0.1/go.mod"
	"github.com/mattn/go-runewidth v0.0.22"
	"github.com/mattn/go-runewidth v0.0.22/go.mod"
	"github.com/muesli/ansi v0.0.0-20230316100256-276c6243b2f6"
	"github.com/muesli/ansi v0.0.0-20230316100256-276c6243b2f6/go.mod"
	"github.com/muesli/cancelreader v0.2.2"
	"github.com/muesli/cancelreader v0.2.2/go.mod"
	"github.com/muesli/termenv v0.16.0"
	"github.com/muesli/termenv v0.16.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/rivo/uniseg v0.4.7"
	"github.com/rivo/uniseg v0.4.7/go.mod"
	"github.com/stretchr/testify v1.11.1"
	"github.com/stretchr/testify v1.11.1/go.mod"
	"github.com/xo/terminfo v0.0.0-20220910002029-abceb7e1c41e"
	"github.com/xo/terminfo v0.0.0-20220910002029-abceb7e1c41e/go.mod"
	"golang.org/x/exp v0.0.0-20231006140011-7918f672742d"
	"golang.org/x/exp v0.0.0-20231006140011-7918f672742d/go.mod"
	"golang.org/x/sys v0.0.0-20210809222454-d867a43fc93e/go.mod"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/sys v0.42.0"
	"golang.org/x/sys v0.42.0/go.mod"
	"golang.org/x/text v0.35.0"
	"golang.org/x/text v0.35.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
)
go-module_set_globals

SRC_URI="https://github.com/umputun/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"
LICENSE="MIT BSD ISC"

SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

BDEPEND=">=dev-lang/go-1.26:="

src_compile() {
	export CGO_ENABLED=0
	go build -v -o "${PN}" -ldflags="-s -w -X main.revision=v${PV}" ./app || die "compile failed"
}

src_install() {
	dobin "${PN}"
	dodoc CHANGELOG.md CONTRIBUTING.md README.md
}
