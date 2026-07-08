# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module shell-completion toolchain-funcs

DESCRIPTION="Install prebuilt binaries from GitHub, GitLab, Gitea/Forgejo and SourceForge"
HOMEPAGE="https://github.com/inherelab/eget"

# generated with: cat go.sum | cut -d' ' -f1,2 | sed -e 's/^/\t"/g' -e 's/$/"/g'
EGO_SUM=(
	"dario.cat/mergo v1.0.2"
	"dario.cat/mergo v1.0.2/go.mod"
	"github.com/BurntSushi/toml v1.6.0"
	"github.com/BurntSushi/toml v1.6.0/go.mod"
	"github.com/andybalholm/brotli v1.2.1"
	"github.com/andybalholm/brotli v1.2.1/go.mod"
	"github.com/bodgit/plumbing v1.3.0"
	"github.com/bodgit/plumbing v1.3.0/go.mod"
	"github.com/bodgit/sevenzip v1.6.2"
	"github.com/bodgit/sevenzip v1.6.2/go.mod"
	"github.com/bodgit/windows v1.0.1"
	"github.com/bodgit/windows v1.0.1/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/go-viper/mapstructure/v2 v2.5.0"
	"github.com/go-viper/mapstructure/v2 v2.5.0/go.mod"
	"github.com/gobwas/glob v0.2.3"
	"github.com/gobwas/glob v0.2.3/go.mod"
	"github.com/goccy/go-yaml v1.19.2"
	"github.com/goccy/go-yaml v1.19.2/go.mod"
	"github.com/gookit/assert v0.1.1"
	"github.com/gookit/assert v0.1.1/go.mod"
	"github.com/gookit/cliui v0.3.2-0.20260624120656-906827b77d7b"
	"github.com/gookit/cliui v0.3.2-0.20260624120656-906827b77d7b/go.mod"
	"github.com/gookit/color v1.6.2-0.20260604125953-289d54c4470a"
	"github.com/gookit/color v1.6.2-0.20260604125953-289d54c4470a/go.mod"
	"github.com/gookit/config/v2 v2.2.8"
	"github.com/gookit/config/v2 v2.2.8/go.mod"
	"github.com/gookit/gcli/v3 v3.8.1"
	"github.com/gookit/gcli/v3 v3.8.1/go.mod"
	"github.com/gookit/goutil v0.8.0"
	"github.com/gookit/goutil v0.8.0/go.mod"
	"github.com/gookit/ini/v2 v2.3.2"
	"github.com/gookit/ini/v2 v2.3.2/go.mod"
	"github.com/hashicorp/golang-lru/v2 v2.0.7"
	"github.com/hashicorp/golang-lru/v2 v2.0.7/go.mod"
	"github.com/klauspost/compress v1.18.5"
	"github.com/klauspost/compress v1.18.5/go.mod"
	"github.com/pierrec/lz4/v4 v4.1.26"
	"github.com/pierrec/lz4/v4 v4.1.26/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/spf13/afero v1.15.0"
	"github.com/spf13/afero v1.15.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/objx v0.4.0/go.mod"
	"github.com/stretchr/objx v0.5.0/go.mod"
	"github.com/stretchr/objx v0.5.2"
	"github.com/stretchr/objx v0.5.2/go.mod"
	"github.com/stretchr/testify v1.7.1/go.mod"
	"github.com/stretchr/testify v1.8.0/go.mod"
	"github.com/stretchr/testify v1.8.1/go.mod"
	"github.com/stretchr/testify v1.11.1"
	"github.com/stretchr/testify v1.11.1/go.mod"
	"github.com/ulikunitz/xz v0.5.15"
	"github.com/ulikunitz/xz v0.5.15/go.mod"
	"github.com/xo/terminfo v0.0.0-20220910002029-abceb7e1c41e"
	"github.com/xo/terminfo v0.0.0-20220910002029-abceb7e1c41e/go.mod"
	"github.com/xyproto/randomstring v1.0.5"
	"github.com/xyproto/randomstring v1.0.5/go.mod"
	"go4.org v0.0.0-20260112195520-a5071408f32f"
	"go4.org v0.0.0-20260112195520-a5071408f32f/go.mod"
	"golang.org/x/exp v0.0.0-20220909182711-5c715a9e8561"
	"golang.org/x/exp v0.0.0-20220909182711-5c715a9e8561/go.mod"
	"golang.org/x/net v0.48.0"
	"golang.org/x/net v0.48.0/go.mod"
	"golang.org/x/sync v0.20.0"
	"golang.org/x/sync v0.20.0/go.mod"
	"golang.org/x/sys v0.40.0"
	"golang.org/x/sys v0.40.0/go.mod"
	"golang.org/x/term v0.38.0"
	"golang.org/x/term v0.38.0/go.mod"
	"golang.org/x/text v0.36.0"
	"golang.org/x/text v0.36.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
)
go-module_set_globals

SRC_URI="https://github.com/inherelab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0 BSD ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror strip"

BDEPEND=">=dev-lang/go-1.25.0:="

src_compile() {
	go build -v -ldflags="-s -w -X main.Version=v${PV}" -o "${PN}" ./cmd/eget || die "compile failed"

	if ! tc-is-cross-compiler; then
		einfo "generating shell completion files"
		./"${PN}" --gen-completion bash > "${PN}".bash || die
		./"${PN}" --gen-completion zsh > "${PN}".zsh || die

		# drop the eget.exe alias registered for Windows/MSYS use
		sed -i -e "s/ ${PN}\.exe$//" "${PN}".bash || die
	fi
}

src_install() {
	dobin "${PN}"
	dodoc README.md README.zh-CN.md docs/example.eget.toml

	if ! tc-is-cross-compiler; then
		newbashcomp "${PN}".bash "${PN}"
		newzshcomp "${PN}".zsh _"${PN}"
	else
		ewarn "Shell completion files not installed! Install them manually with '${PN} --gen-completion bash|zsh'"
	fi
}
