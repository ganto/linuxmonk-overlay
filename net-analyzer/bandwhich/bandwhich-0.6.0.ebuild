# Copyright 2017-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.2.0

EAPI=7

CRATES="
adler32-1.0.4
aho-corasick-0.6.10
aho-corasick-0.7.6
ansi_term-0.11.0
arc-swap-0.4.3
async-trait-0.1.21
atty-0.2.13
autocfg-0.1.7
backtrace-0.3.40
backtrace-sys-0.1.32
bandwhich-0.6.0
bitflags-0.5.0
bitflags-1.2.1
block-buffer-0.7.3
block-padding-0.1.5
byte-tools-0.3.1
byteorder-1.3.2
bytes-0.5.0
c2-chacha-0.2.3
cargo-insta-0.11.0
cassowary-0.3.0
cc-1.0.47
cfg-if-0.1.9
chrono-0.4.9
clap-2.33.0
clicolors-control-1.0.1
cloudabi-0.0.3
console-0.7.7
console-0.8.0
crc32fast-1.2.0
derive-new-0.5.8
difference-2.0.0
digest-0.8.1
dtoa-0.4.4
either-1.5.3
encode_unicode-0.3.6
enum-as-inner-0.3.0
failure-0.1.6
failure_derive-0.1.6
fake-simd-0.1.2
fnv-1.0.6
fuchsia-cprng-0.1.1
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.3.1
futures-channel-0.3.1
futures-core-0.3.1
futures-executor-0.3.1
futures-io-0.3.1
futures-macro-0.3.1
futures-sink-0.3.1
futures-task-0.3.1
futures-util-0.3.1
generic-array-0.12.3
getrandom-0.1.13
glob-0.2.11
heck-0.3.1
hex-0.4.0
hostname-0.1.5
idna-0.2.0
insta-0.11.0
iovec-0.1.4
ipconfig-0.2.1
ipnetwork-0.12.8
ipnetwork-0.15.0
itertools-0.8.1
itoa-0.4.4
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.65
libflate-0.1.27
linked-hash-map-0.5.2
lock_api-0.3.1
log-0.3.9
log-0.4.8
lru-cache-0.1.2
maplit-1.0.2
matches-0.1.8
maybe-uninit-2.0.0
memchr-2.2.1
mio-0.6.21
miow-0.2.1
net2-0.2.33
num-integer-0.1.41
num-traits-0.2.8
numtoa-0.1.0
opaque-debug-0.2.3
packet-builder-0.4.0
parking_lot-0.9.0
parking_lot_core-0.6.2
percent-encoding-2.1.0
pest-2.1.2
pest_derive-2.1.0
pest_generator-2.1.1
pest_meta-2.1.2
pin-project-lite-0.1.1
pin-utils-0.1.0-alpha.4
pnet-0.23.0
pnet_base-0.23.0
pnet_datalink-0.23.0
pnet_macros-0.21.0
pnet_macros_support-0.23.0
pnet_packet-0.23.0
pnet_sys-0.23.0
pnet_transport-0.23.0
ppv-lite86-0.2.6
proc-macro-error-0.2.6
proc-macro-hack-0.5.11
proc-macro-nested-0.1.3
proc-macro2-0.4.30
proc-macro2-1.0.6
procfs-0.7.4
quick-error-1.2.2
quote-0.6.13
quote-1.0.2
rand-0.6.5
rand-0.7.2
rand_chacha-0.1.1
rand_chacha-0.2.1
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_hc-0.1.0
rand_hc-0.2.0
rand_isaac-0.1.1
rand_jitter-0.1.4
rand_os-0.1.3
rand_pcg-0.1.2
rand_xorshift-0.1.1
rdrand-0.4.0
redox_syscall-0.1.56
redox_termios-0.1.1
regex-0.2.11
regex-1.3.1
regex-syntax-0.5.6
regex-syntax-0.6.12
resolv-conf-0.6.2
rle-decode-fast-1.0.1
rustc-demangle-0.1.16
rustc-serialize-0.3.24
rustc_version-0.2.3
ryu-1.0.2
same-file-1.0.5
scopeguard-1.0.0
semver-0.9.0
semver-parser-0.7.0
serde-1.0.102
serde_derive-1.0.102
serde_json-1.0.41
serde_yaml-0.8.11
sha-1-0.8.1
signal-hook-0.1.11
signal-hook-registry-1.1.1
slab-0.4.2
smallvec-0.6.13
smallvec-1.0.0
socket2-0.3.11
strsim-0.8.0
structopt-0.2.18
structopt-0.3.4
structopt-derive-0.2.18
structopt-derive-0.3.4
syn-0.15.44
syn-1.0.8
synstructure-0.12.3
syntex-0.42.2
syntex_errors-0.42.0
syntex_pos-0.42.0
syntex_syntax-0.42.0
take_mut-0.2.2
term-0.4.6
termion-1.5.3
termios-0.3.1
textwrap-0.11.0
thread_local-0.3.6
time-0.1.42
tokio-0.2.2
trust-dns-proto-0.18.0-alpha.2
trust-dns-resolver-0.18.0-alpha.2
tui-0.5.1
typenum-1.11.2
ucd-trie-0.1.2
ucd-util-0.1.5
unicode-bidi-0.3.4
unicode-normalization-0.1.9
unicode-segmentation-1.6.0
unicode-width-0.1.6
unicode-xid-0.0.3
unicode-xid-0.1.0
unicode-xid-0.2.0
url-2.1.0
utf8-ranges-1.0.4
uuid-0.7.4
vec_map-0.8.1
walkdir-2.2.9
wasi-0.7.0
widestring-0.4.0
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.2
winapi-x86_64-pc-windows-gnu-0.4.0
winreg-0.6.2
winutil-0.1.1
ws2_32-sys-0.2.1
yaml-rust-0.4.3
"

inherit cargo

DESCRIPTION="Terminal bandwidth utilization tool"
HOMEPAGE="https://github.com/imsnif/bandwhich"
SRC_URI="$(cargo_crate_uris ${CRATES})"
RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	>=virtual/rust-1.39.0
"

DOCS=( README.md )

src_install() {
	cargo_src_install

	dodoc "${DOCS[@]}"
	doman docs/bandwhich.1
}