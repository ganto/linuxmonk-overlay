# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler2@2.0.1
	aho-corasick@1.1.4
	allocator-api2@0.2.21
	anstyle@1.0.14
	anyhow@1.0.102
	atomic@0.6.1
	autocfg@1.5.0
	base64@0.22.1
	bincode@2.0.1
	bincode_derive@2.0.1
	bit-set@0.5.3
	bit-vec@0.6.3
	bitflags@1.3.2
	bitflags@2.11.0
	block-buffer@0.10.4
	block2@0.6.2
	bumpalo@3.20.2
	bytemuck@1.25.0
	bytes@1.11.1
	castaway@0.2.4
	cfg-if@1.0.4
	cfg_aliases@0.1.1
	cfg_aliases@0.2.1
	clap@4.6.1
	clap_builder@4.6.0
	clap_complete@4.6.5
	clap_lex@1.1.0
	compact_str@0.9.0
	convert_case@0.10.0
	cpufeatures@0.2.17
	crc32fast@1.5.0
	crossterm@0.29.0
	crossterm_winapi@0.9.1
	crypto-common@0.1.7
	csscolorparser@0.6.2
	ctrlc@3.5.2
	darling@0.23.0
	darling_core@0.23.0
	darling_macro@0.23.0
	deltae@0.3.2
	deranged@0.5.8
	derive_more-impl@2.1.1
	derive_more@2.1.1
	digest@0.10.7
	dispatch2@0.3.1
	doctest-file@1.1.1
	document-features@0.2.12
	downcast-rs@1.2.1
	dyn-clone@1.0.20
	either@1.15.0
	equivalent@1.0.2
	errno@0.3.14
	euclid@0.22.14
	fancy-regex@0.11.0
	fdeflate@0.3.7
	filedescriptor@0.8.3
	finl_unicode@1.4.0
	fixedbitset@0.4.2
	flate2@1.1.9
	fnv@1.0.7
	foldhash@0.1.5
	foldhash@0.2.0
	futures-channel@0.3.33
	futures-core@0.3.33
	futures-executor@0.3.33
	futures-io@0.3.33
	futures-macro@0.3.33
	futures-sink@0.3.33
	futures-task@0.3.33
	futures-util@0.3.33
	futures@0.3.33
	generic-array@0.14.7
	getrandom@0.3.4
	getrandom@0.4.2
	hashbrown@0.15.5
	hashbrown@0.16.1
	heck@0.5.0
	hex@0.4.3
	id-arena@2.3.0
	ident_case@1.0.1
	indexmap@2.13.0
	indoc@2.0.7
	instability@0.3.12
	interprocess@2.4.2
	itertools@0.14.0
	itoa@1.0.18
	js-sys@0.3.91
	jsonc-parser@0.33.1
	kasuari@0.4.12
	lab@0.11.0
	lazy_static@1.5.0
	leb128fmt@0.1.0
	libc@0.2.183
	line-clipping@0.3.5
	linux-raw-sys@0.12.1
	litrs@1.0.0
	lock_api@0.4.14
	log@0.4.29
	lru@0.16.3
	mac_address@1.1.8
	matchers@0.2.0
	memchr@2.8.0
	memmem@0.1.1
	memoffset@0.9.1
	minimal-lexical@0.2.1
	miniz_oxide@0.8.9
	mio@1.1.1
	nix@0.28.0
	nix@0.29.0
	nix@0.31.2
	nom@7.1.3
	nu-ansi-term@0.50.3
	num-conv@0.2.1
	num-derive@0.4.2
	num-traits@0.2.19
	num_threads@0.1.7
	objc2-encode@4.1.0
	objc2@0.6.4
	once_cell@1.21.4
	ordered-float@4.6.0
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	pest@2.8.6
	pest_derive@2.8.6
	pest_generator@2.8.6
	pest_meta@2.8.6
	phf@0.11.3
	phf_codegen@0.11.3
	phf_generator@0.11.3
	phf_macros@0.11.3
	phf_shared@0.11.3
	pin-project-lite@0.2.17
	png@0.17.16
	portable-atomic@1.13.1
	powerfmt@0.2.0
	prettyplease@0.2.37
	proc-macro2@1.0.106
	quote@1.0.45
	r-efi@5.3.0
	r-efi@6.0.0
	rand@0.8.5
	rand_core@0.6.4
	ratatui-core@0.1.0
	ratatui-crossterm@0.1.0
	ratatui-macros@0.7.0
	ratatui-termwiz@0.1.0
	ratatui-widgets@0.3.0
	ratatui@0.30.0
	recvmsg@1.0.0
	redox_syscall@0.5.18
	ref-cast-impl@1.0.25
	ref-cast@1.0.25
	regex-automata@0.4.14
	regex-syntax@0.8.10
	regex@1.12.3
	rustc_version@0.4.1
	rustix@1.1.4
	rustversion@1.0.22
	ryu@1.0.23
	schemars@1.2.1
	schemars_derive@1.2.1
	scopeguard@1.2.0
	semver@1.0.27
	serde@1.0.228
	serde_core@1.0.228
	serde_derive@1.0.228
	serde_derive_internals@0.29.1
	serde_ignored@0.1.14
	serde_json@1.0.149
	serde_spanned@0.6.9
	serial2@0.2.34
	sha2@0.10.9
	sharded-slab@0.1.7
	shell-words@1.1.1
	signal-hook-mio@0.2.5
	signal-hook-registry@1.4.8
	signal-hook@0.3.18
	simd-adler32@0.3.9
	siphasher@1.0.2
	slab@0.4.12
	smallvec@1.15.1
	static_assertions@1.1.0
	strsim@0.11.1
	strum@0.27.2
	strum_macros@0.27.2
	syn@1.0.109
	syn@2.0.117
	terminfo@0.9.0
	termios@0.3.3
	termwiz@0.23.3
	thiserror-impl@1.0.69
	thiserror-impl@2.0.18
	thiserror@1.0.69
	thiserror@2.0.18
	thread_local@1.1.9
	time-core@0.1.8
	time-macros@0.2.27
	time@0.3.47
	tokio-macros@2.6.1
	tokio@1.50.0
	toml@0.8.23
	toml_datetime@0.6.11
	toml_edit@0.22.27
	toml_write@0.1.2
	tracing-attributes@0.1.31
	tracing-core@0.1.36
	tracing-log@0.2.0
	tracing-subscriber@0.3.23
	tracing@0.1.44
	typenum@1.19.0
	ucd-trie@0.1.7
	unicode-ident@1.0.24
	unicode-segmentation@1.13.1
	unicode-truncate@2.0.1
	unicode-width@0.2.2
	unicode-xid@0.2.6
	unty@0.0.4
	utf8parse@0.2.2
	uuid@1.22.0
	valuable@0.1.1
	version_check@0.9.5
	virtue@0.0.18
	vtparse@0.6.2
	wasi@0.11.1+wasi-snapshot-preview1
	wasip2@1.0.2+wasi-0.2.9
	wasip3@0.4.0+wasi-0.3.0-rc-2026-01-06
	wasm-bindgen-macro-support@0.2.114
	wasm-bindgen-macro@0.2.114
	wasm-bindgen-shared@0.2.114
	wasm-bindgen@0.2.114
	wasm-encoder@0.244.0
	wasm-metadata@0.244.0
	wasmparser@0.244.0
	wezterm-bidi@0.2.3
	wezterm-blob-leases@0.1.1
	wezterm-color-types@0.3.0
	wezterm-dynamic-derive@0.1.1
	wezterm-dynamic@0.2.1
	wezterm-input-types@0.1.0
	widestring@1.2.1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-collections@0.3.2
	windows-core@0.62.2
	windows-future@0.3.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-numerics@0.3.1
	windows-result@0.4.1
	windows-strings@0.5.1
	windows-sys@0.61.2
	windows-threading@0.2.1
	windows@0.62.2
	winnow@0.7.15
	winreg@0.10.1
	wit-bindgen-core@0.51.0
	wit-bindgen-rust-macro@0.51.0
	wit-bindgen-rust@0.51.0
	wit-bindgen@0.51.0
	wit-component@0.244.0
	wit-parser@0.244.0
	wmi@0.18.4
	zmij@1.0.21
"

# Zig package dependencies of vendor/libghostty-vt (Ghostty Zig source
# vendored by herdr).  Generated by:
#   ./gen-zig-deps.py <S>/vendor/libghostty-vt/build.zig.zon.json
# NOTE: Keep in sync with x11-terms/ghostty-terminfo; distfiles are
#       identical and share the same DISTDIR entries.
declare -g -r -A ZBS_DEPENDENCIES=(
	[N-V-__8AAB0eQwD-0MdOEBmz7intriBReIsIDNlukNVoNu6o.tar.gz]='https://deps.files.ghostty.org/zlib-1220fed0c74e1019b3ee29edae2051788b080cd96e90d56836eea857b0b966742efb.tar.gz'
	[N-V-__8AABzkUgISeKGgXAzgtutgJsZc0-kkeqBBscJgMkvy.tar.gz]='https://deps.files.ghostty.org/glslang-12201278a1a05c0ce0b6eb6026c65cd3e9247aa041b1c260324bf29cee559dd23ba1.tar.gz'
	[N-V-__8AADYiAAB_80AWnH1AxXC0tql9thT-R-DYO1gBqTLc.tar.gz]='https://deps.files.ghostty.org/pixels-12207ff340169c7d40c570b4b6a97db614fe47e0d83b5801a932dcd44917424c8806.tar.gz'
	[N-V-__8AADcZkgn4cMhTUpIz6mShCKyqqB-NBtf_S2bHaTC-.tar.gz]='https://deps.files.ghostty.org/gettext-0.24.tar.gz'
	[N-V-__8AAEFmBABuDGOKxAI6VMg41b9euMZ-z7HS9EcUdaor.tgz]='https://deps.files.ghostty.org/ghostty-themes-release-20260831-151010-752a9c0.tgz'
	[N-V-__8AAEbOfQBnvcFcCX2W5z7tDaN8vaNZGamEQtNOe0UI.tar.gz]='https://deps.files.ghostty.org/N-V-__8AAEbOfQBnvcFcCX2W5z7tDaN8vaNZGamEQtNOe0UI.tar.gz'
	[N-V-__8AAFdWDwA0ktbNUi9pFBHCRN4weXIgIfCrVjfGxqgA.tar.gz]='https://deps.files.ghostty.org/N-V-__8AAFdWDwA0ktbNUi9pFBHCRN4weXIgIfCrVjfGxqgA.tar.gz'
	[N-V-__8AAG02ugUcWec-Ndp-i7JTsJ0dgF8nnJRUInkGLG7G.tar.xz]='https://deps.files.ghostty.org/harfbuzz-11.0.0.tar.xz'
	[N-V-__8AAG3RoQEyRC2Vw7Qoro5SYBf62IHn3HjqtNVY6aWK.tar.gz]='https://deps.files.ghostty.org/libxml2-2.11.5.tar.gz'
	[N-V-__8AAGmZhABbsPJLfbqrh6JTHsXhY6qCaLAQyx25e0XE.tar.gz]='https://deps.files.ghostty.org/highway-66486a10623fa0d72fe91260f96c892e41aceb06.tar.gz'
	[N-V-__8AAHjwMQDBXnLq3Q2QhaivE0kE2aD138vtX2Bq1g7c.tar.gz]='https://deps.files.ghostty.org/oniguruma-1220c15e72eadd0d9085a8af134904d9a0f5dfcbed5f606ad60edc60ebeccd9706bb.tar.gz'
	[N-V-__8AAIC5lwAVPJJzxnCAahSvZTIlG-HhtOvnM1uh-66x.tar.gz]='https://deps.files.ghostty.org/JetBrainsMono-2.304.tar.gz'
	[N-V-__8AAJrvXQCqAT8Mg9o_tk6m0yf5Fz-gCNEOKLyTSerD.tar.gz]='https://deps.files.ghostty.org/libpng-1220aa013f0c83da3fb64ea6d327f9173fa008d10e28bc9349eac3463457723b1c66.tar.gz'
	[N-V-__8AAKLKpwC4H27Ps_0iL3bPkQb-z6ZVSrB-x_3EEkub.tar.gz]='https://deps.files.ghostty.org/freetype-1220b81f6ecfb3fd222f76cf9106fecfa6554ab07ec7fdc4124b9bb063ae2adf969d.tar.gz'
	[N-V-__8AAKYZBAB-CFHBKs3u4JkeiT4BMvyHu3Y5aaWF3Bbs.tar.gz]='https://deps.files.ghostty.org/plasma_wayland_protocols-12207e0851c12acdeee0991e893e0132fc87bb763969a585dc16ecca33e88334c566.tar.gz'
	[N-V-__8AAKrHGAAs2shYq8UkE6bGcR1QJtLTyOE_lcosMn6t.tar.gz]='https://deps.files.ghostty.org/wayland-9cb3d7aa9dc995ffafdbdef7ab86a949d0fb0e7d.tar.gz'
	[N-V-__8AAKw-DAAaV8bOAAGqA0-oD7o-HNIlPFYKRXSPT03S.tar.gz]='https://deps.files.ghostty.org/wayland-protocols-258d8f88f2c8c25a830c6316f87d23ce1a0f12d9.tar.gz'
	[N-V-__8AALiNBAA-_0gprYr92CjrMj1I5bqNu0TSJOnjFNSr.tar.gz]='https://deps.files.ghostty.org/gtk4-layer-shell-1.1.0.tar.gz'
	[N-V-__8AALw2uwF_03u4JRkZwRLc3Y9hakkYV7NKRR9-RIZJ.tar.gz]='https://deps.files.ghostty.org/breakpad-b99f444ba5f6b98cac261cbb391d8766b34a5918.tar.gz'
	[N-V-__8AAMVLTABmYkLqhZPLXnMl-KyN38R8UVYqGrxqO26s.tar.gz]='https://deps.files.ghostty.org/NerdFontsSymbolsOnly-3.4.0.tar.gz'
	[N-V-__8AANT61wB--nJ95Gj_ctmzAtcjloZ__hRqNw5lC1Kr.tar.gz]='https://deps.files.ghostty.org/DearBindings_v0.17_ImGui_v1.92.5-docking.tar.gz'
	[N-V-__8AANb6pwD7O1WG6L5nvD_rNMvnSc9Cpg1ijSlTYywv.tar.gz]='https://deps.files.ghostty.org/spirv_cross-1220fb3b5586e8be67bc3feb34cbe749cf42a60d628d2953632c2f8141302748c8da.tar.gz'
	[N-V-__8AAOgqbADacob-q2_DMQlmgaG4xKHRuW-6PJ4oJzMZ.tar.xz]='https://gitlab.freedesktop.org/api/v4/projects/890/packages/generic/fontconfig/2.18.3/fontconfig-2.18.3.tar.xz'
	[N-V-__8AAP5JWgCGP_AD0teWpa4krRvE9VPZzvviGdbmN4jI.tar.gz]='https://deps.files.ghostty.org/wuffs-7411f488fe2e2c205c3d3b3d28638b7356522930.tar.gz'
	[N-V-__8AAPlZGwBEa-gxrcypGBZ2R8Bse4JYSfo_ul8i2jlG.tar.gz]='https://deps.files.ghostty.org/sentry-1220446be831adcca918167647c06c7b825849fa3fba5f22da394667974537a9c77e.tar.gz'
	[aro-0.0.0-JSD1Qk6lNgDdcDV4Vh7Sfy-34m2TluIVOdPzMmj_0BjX.tar.gz]='https://github.com/vancluever/arocc/archive/f97cdfc3779aec4b242299e2fc9a1c828c3547c6.tar.gz'
	[gobject-0.3.2-Skun7F6HogCMynX2JqeSHS7xr-8pK4ob-qRFIcEasVi3.tar.zst]='https://deps.files.ghostty.org/gobject-2026-07-28-36-1.tar.zst'
	[libxev-0.0.0-86vtcwIRFADbH4hk-EjROXxlrKIRPQdA41XiTSytYO-F.tar.gz]='https://deps.files.ghostty.org/libxev-9ce8e8e6ff89e583258a7f8e7adeeeaeae8611bf.tar.gz'
	[translate_c-0.0.0-Q_BUWhVNBwDOEcIqub4VFPJPB6D9dgwzUMHTX5KWr8Xr.tar.gz]='https://codeberg.org/vancluever/translate-c/archive/4e879eb8aba615de112eabd1231ea6e01920cead.tar.gz'
	[uucode-0.2.0-ZZjBPlK5VADj7fdoq7G8LIHzD5o6FSkcBXXrRWr4jnrA.tar.gz]='https://deps.files.ghostty.org/uucode-2826a37a4562284fdacd8fa029d49509cc9bffcd.tar.gz'
	[vaxis-0.6.0-BWNV_CrbCQCscGpzsAlR402rYQ_tV3aAl081c2iRRkka.tar.gz]='https://deps.files.ghostty.org/vaxis-1dbbe575dff4586fe51e3217aa5c3fecdcbb6089.tar.gz'
	[vaxis-0.6.0-BWNV_MjFCQCs9UDHiRkrgw_ayeiPkzOe4xVbaAqXkUWW.tar.gz]='https://github.com/rockorager/libvaxis/archive/c1e1f23be38951c425cdf31af455ba23ef178940.tar.gz'
	[wayland-0.6.0-lQa1kqz8AQADQmdNJsNhLoNHcnEGEUjrOaPV-dtEnEmX.tar.gz]='https://deps.files.ghostty.org/wayland-0.6.0-lQa1kqz8AQADQmdNJsNhLoNHcnEGEUjrOaPV-dtEnEmX.tar.gz'
	[z2d-0.12.1-j5P_Hsw8EQAKyZTQICCQnAH2xYkLDW8k9uefbsYdfPZ-.tar.gz]='https://deps.files.ghostty.org/z2d-7dbae85c81784dba9988320bf9543ed9a81350c8.tar.gz'
	[zf-0.11.0-OIRy8X-RAAAwaRXHMYpj2uvBnuGTZWEE_3V7acqHQNtW.tar.gz]='https://deps.files.ghostty.org/zf-c35c421f84895193246db06c40683c1a30e616ef.tar.gz'
	[zig_js-0.0.0-rjCAV7-GAADvMTBL7lPMuvDk7xgS9PCMIZWiOUXLZSlj.tar.gz]='https://deps.files.ghostty.org/zig_js-3c23860e47fdcdc5af805efb7fd0bdac5fd3e9bc.tar.gz'
	[zig_objc-0.0.0-Ir_Sp9gsAQCPAJc0oF5xoWePHWP6Y6tCphDeyNUThJoi.tar.gz]='https://deps.files.ghostty.org/zig_objc-c8de82ff80281215ad92900866dab7103a8efa8b.tar.gz'
	[zigimg-0.1.0-8_eo2oyaFwBZwJpmqPkCfVXWBrHcqbYwmrp1I6bTD3lI.tar.gz]='https://github.com/zigimg/zigimg/archive/d695acd97c02e57bb151e8f659d1280f5cd6ca70.tar.gz'
)

ZIG_SLOT="0.16"
ZIG_OPTIONAL=1
RUST_MIN_VER="1.88.0"
inherit zig cargo

DESCRIPTION="Terminal workspace manager for AI coding agents"
HOMEPAGE="https://herdr.dev https://github.com/ogulcancelik/herdr"
SRC_URI="https://github.com/ogulcancelik/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
	${ZBS_DEPENDENCIES_SRC_URI}"

LICENSE="AGPL-3+ Apache-2.0 MIT Unicode-DFS-2016"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

# ZIG_OPTIONAL suppresses zig.eclass auto-BDEPEND; declare Zig deps manually.
BDEPEND="
	|| (
		dev-lang/zig:0.16
		dev-lang/zig-bin:0.16
	)
	virtual/pkgconfig
"

# Zig Build System ignores CFLAGS/LDFLAGS; silence QA warnings for the
# libghostty-vt objects compiled by Zig.
QA_FLAGS_IGNORED=".*"

DOCS=( README.md )

src_prepare() {
	default

	# Pre-populate an offline Zig package directory for vendor/libghostty-vt,
	# whose Zig package manager dependencies would otherwise be fetched at
	# build time (network access is blocked in the sandbox).
	#
	# zig-utils_setup detects the slotted Zig installation and sets ZIG_EXE,
	# ZIG_TARGET, and ZIG_CPU.  ezig then wraps ${ZIG_EXE} with sandbox-safe
	# environment variables.
	zig-utils_setup

	# Zig >=0.16's "zig fetch" no longer extracts folder packages when a
	# --global-cache-dir is given (it only stores the compressed archive
	# there).  Without --global-cache-dir, it still extracts tarballs into
	# "./zig-pkg/<hash>/" relative to CWD (stripping the single top-level
	# directory the same way older Zig releases did), which is the layout
	# vendor/libghostty-vt's build.rs expects for "zig build --system".
	# "zig fetch" also requires a build.zig file to exist in CWD.
	local zig_gcache="${WORKDIR}/zig-gcache"
	mkdir -p "${zig_gcache}" || die
	pushd "${zig_gcache}" > /dev/null || die
	touch build.zig || die

	local dep
	for dep in "${!ZBS_DEPENDENCIES[@]}"; do
		ezig fetch "${DISTDIR}/${dep}" > /dev/null
	done

	# Keep the "p/" directory name used by older Zig's
	# "--global-cache-dir"-based fetch, for consistency.
	mv zig-pkg p || die

	popd > /dev/null || die
}

src_compile() {
	# "zig fetch" unpacks folder packages under <gcache>/p/<hash>/, which is
	# the layout that vendor/libghostty-vt's build.rs expects when its
	# LIBGHOSTTY_VT_ZIG_SYSTEM_DIR is set (equivalent to "zig build --system").
	export LIBGHOSTTY_VT_ZIG_SYSTEM_DIR="${WORKDIR}/zig-gcache/p"
	# build.rs shells out to "zig build" for vendor/libghostty-vt and
	# otherwise falls back to whatever "zig" is first in PATH (which may
	# be a different, unslotted Zig).  Point it at the Zig binary that
	# zig-utils_setup selected for ZIG_SLOT.
	export ZIG="${ZIG_EXE}"
	cargo_src_compile
}

src_test() {
	# Upstream's full integration suite is written for cargo-nextest isolation.
	RUST_TEST_THREADS=1 cargo_src_test --bin herdr
}

src_install() {
	cargo_src_install
	dodoc "${DOCS[@]}"
	insinto /usr/share/herdr/skills/herdr
	doins skills/herdr/SKILL.md
}

pkg_postinst() {
	elog "The Herdr agent skill is available at /usr/share/herdr/skills/herdr/SKILL.md."
}
