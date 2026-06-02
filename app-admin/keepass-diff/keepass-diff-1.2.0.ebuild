# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler@1.0.2
	aes@0.8.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.4
	anstyle@1.0.4
	anstyle-parse@0.2.2
	anstyle-query@1.0.0
	anstyle-wincon@3.0.1
	arrayref@0.3.7
	arrayvec@0.7.4
	autocfg@1.1.0
	base64@0.21.5
	bitflags@2.4.1
	blake2b_simd@1.0.2
	block-buffer@0.10.4
	block-modes@0.9.1
	block-padding@0.3.3
	bumpalo@3.14.0
	byteorder@1.5.0
	cbc@0.1.2
	cc@1.0.83
	cfg-if@1.0.0
	chacha20@0.9.1
	chrono@0.4.31
	cipher@0.4.4
	clap@4.4.7
	clap_builder@4.4.7
	clap_derive@4.4.7
	clap_lex@0.6.0
	colorchoice@1.0.0
	constant_time_eq@0.3.0
	core-foundation-sys@0.8.4
	cpufeatures@0.2.11
	crc32fast@1.3.2
	crypto-common@0.1.6
	digest@0.10.7
	errno@0.3.5
	flate2@1.0.28
	generic-array@0.14.7
	getrandom@0.2.10
	heck@0.4.1
	hex-literal@0.4.1
	hmac@0.12.1
	iana-time-zone@0.1.58
	iana-time-zone-haiku@0.1.2
	inout@0.1.3
	js-sys@0.3.65
	keepass@0.6.6
	libc@0.2.150
	linux-raw-sys@0.4.10
	log@0.4.20
	miniz_oxide@0.7.1
	num-traits@0.2.17
	once_cell@1.18.0
	proc-macro2@1.0.69
	quote@1.0.33
	rpassword@7.2.0
	rtoolbox@0.0.1
	rust-argon2@2.0.0
	rustix@0.38.21
	salsa20@0.10.2
	secstr@0.5.1
	serde@1.0.190
	serde_derive@1.0.190
	sha2@0.10.8
	strsim@0.10.0
	subtle@2.5.0
	syn@2.0.38
	termcolor@1.3.0
	terminal_size@0.3.0
	thiserror@1.0.50
	thiserror-impl@1.0.50
	twofish@0.7.1
	typenum@1.17.0
	unicode-ident@1.0.12
	utf8parse@0.2.1
	uuid@1.5.0
	version_check@0.9.4
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen@0.2.88
	wasm-bindgen-backend@0.2.88
	wasm-bindgen-macro@0.2.88
	wasm-bindgen-macro-support@0.2.88
	wasm-bindgen-shared@0.2.88
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	windows-core@0.51.1
	windows-sys@0.48.0
	windows-targets@0.48.5
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_msvc@0.48.5
	windows_i686_gnu@0.48.5
	windows_i686_msvc@0.48.5
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_msvc@0.48.5
	xml-rs@0.8.19
	zeroize@1.6.0
	zeroize_derive@1.4.2
"

inherit cargo

DESCRIPTION="This CLI-tool reads two Keepass (.kdbx) files and prints their differences."
HOMEPAGE="https://narigo.github.io/keepass-diff/ https://github.com/Narigo/keepass-diff"
SRC_URI="https://static.crates.io/crates/${PN}/${P}.crate
	${CARGO_CRATE_URIS}"
LICENSE="0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 CC0-1.0 MIT Unlicense ZLIB"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

DOCS=( README.md )
