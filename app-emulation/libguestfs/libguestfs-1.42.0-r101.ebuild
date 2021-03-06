# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 lua5-2 lua5-3 lua5-4 )
PYTHON_COMPAT=( python3_{7,8} )

inherit autotools bash-completion-r1 l10n linux-info lua-single perl-functions python-single-r1 xdg-utils

MY_PV_1="$(ver_cut 1-2)"
MY_PV_2="$(ver_cut 2)"
[[ $(( ${MY_PV_2} % 2 )) -eq 0 ]] && SD="stable" || SD="development"

DESCRIPTION="Tools for accessing, inspect  and modifying virtual machine (VM) disk images"
HOMEPAGE="http://libguestfs.org/"
SRC_URI="http://libguestfs.org/download/${MY_PV_1}-${SD}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0/"${MY_PV_1}""

KEYWORDS="~amd64"
IUSE="doc erlang +fuse inspect-icons introspection libvirt lua ocaml +perl python ruby selinux static-libs systemtap test"
RESTRICT="!test? ( test )"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )"

# Failures - doc

# FIXME: selinux support is automagic
COMMON_DEPEND="
	sys-libs/ncurses:0=
	sys-devel/gettext
	>=app-misc/hivex-1.3.1
	dev-libs/libpcre:3
	app-arch/cpio
	dev-lang/perl:=
	app-cdr/cdrtools
	>=app-emulation/qemu-2.0[qemu_softmmu_targets_x86_64,systemtap?,selinux?,filecaps]
	sys-apps/fakeroot
	sys-apps/file
	libvirt? ( app-emulation/libvirt )
	dev-libs/libxml2:2=
	>=sys-apps/fakechroot-2.8
	>=app-admin/augeas-1.8.0
	sys-fs/squashfs-tools:*
	dev-libs/libconfig:=
	sys-libs/readline:0=
	>=sys-libs/db-4.6:*
	app-arch/xz-utils
	app-arch/lzma
	app-crypt/gnupg
	app-arch/unzip[natspec]
	perl? (
		>=app-misc/hivex-1.3.1[perl?]
		dev-perl/libintl-perl
		dev-perl/Module-Build
		>=dev-perl/Sys-Virt-0.2.4
		virtual/perl-Getopt-Long
		virtual/perl-ExtUtils-CBuilder
		virtual/perl-ExtUtils-MakeMaker
	)
	python? ( ${PYTHON_DEPS} )
	fuse? ( sys-fs/fuse:= )
	introspection? (
		>=dev-libs/glib-2.26:2
		>=dev-libs/gobject-introspection-1.30.0:=
	)
	selinux? (
		sys-libs/libselinux
		sys-libs/libsemanage
	)
	systemtap? ( dev-util/systemtap )
	ocaml? ( >=dev-lang/ocaml-4.03:=[ocamlopt] )
	erlang? ( dev-lang/erlang )
	inspect-icons? (
		media-libs/netpbm
		media-gfx/icoutils
	)
	virtual/acl
	sys-libs/libcap
	lua? ( ${LUA_DEPS} )
	>=dev-libs/yajl-2.0.4
	net-libs/libtirpc:=
	sys-libs/libxcrypt:=
	"
DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	>=dev-lang/ocaml-4.03:=[ocamlopt]
	dev-ml/findlib[ocamlopt]
	|| (
		<dev-ml/ocaml-gettext-0.4.2
		dev-ml/ocaml-gettext-stub[ocamlopt]
	)
	dev-ml/ounit2[ocamlopt]
	doc? ( app-text/po4a )
	ruby? ( dev-lang/ruby virtual/rubygems dev-ruby/rake )
	test? ( introspection? ( dev-libs/gjs ) )
	"
RDEPEND="${COMMON_DEPEND}
	app-emulation/libguestfs-appliance
	"
# Upstream build scripts compile and install Lua bindings for the ABI version
# obtained by running 'lua' on the build host
BDEPEND="lua? ( ${LUA_DEPS} )"

DOCS=( AUTHORS BUGS ChangeLog HACKING README TODO )

PATCHES=(
	"${FILESDIR}"/1.38-0001-Fix-install-failure-when-not-built-with-OCaml-suppor.patch
	"${FILESDIR}"/1.38-0002-Loosen-build-time-requirement-on-bash-completion.patch
	"${FILESDIR}"/1.38-0003-Fix-libxcrypt.patch
	"${FILESDIR}"/1.42-0001-po-Remove-virt-v2v-related-dependency-from-POTFILES-.patch
	"${FILESDIR}"/1.42-0001-appliance-Set-default-guestfs-appliance-path-to-libd.patch
)

pkg_setup() {
		CONFIG_CHECK="~KVM ~VIRTIO"
		[ -n "${CONFIG_CHECK}" ] && check_extra_config;

		use lua && lua-single_pkg_setup
		use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	xdg_environment_reset
	eautoreconf

	# Replace developer-centric README that ships with libguestfs, with
	# our replacement file
	mv README README.orig
	sed "s/@VERSION@/${PV}/g" < "${FILESDIR}"/README-replacement.in > README
}

src_configure() {
	# Disable feature test for kvm for more reason
	# i.e: not loaded module in __build__ time,
	# build server not supported kvm, etc. ...
	#
	# In fact, this feature is virtio support and requires
	# configured kernel.
	export vmchannel_test=no

	econf \
		--with-bashcompletiondir="$(get_bashcompdir)" \
		$(use_with libvirt) \
		--disable-appliance \
		--disable-daemon \
		--with-extra="-gentoo" \
		--with-readline \
		--disable-php \
		$(use_enable python) \
		--without-java \
		$(use_enable perl) \
		$(use_enable fuse) \
		$(use_enable ocaml) \
		$(use_enable ruby) \
		--disable-haskell \
		--disable-golang \
		$(use_enable introspection gobject) \
		$(use_enable introspection) \
		$(use_enable erlang) \
		$(use_enable static-libs static) \
		$(use_enable systemtap probes) \
		$(use_enable lua) \
		$(usex doc '' PO4A=no)
}

src_install() {
	strip-linguas -i po
	emake DESTDIR="${D}" install "INSTALLDIRS=vendor LINGUAS=""${LINGUAS}"""
	dodoc "${DOCS[@]}"

	# Delete libtool files
	find "${ED}" -name '*.la' -delete || die

	# Delete some bogus Perl files
	use perl && perl_delete_localpod

	# Build python modules
	use python && python_optimize

	# Guestfish colour prompts
	insinto /etc/profile.d/
	doins "${FILESDIR}"/guestfish.sh

	# Remove obsolete binaries (RHBZ#1213298)
	rm "${ED}"/usr/bin/virt-list-filesystems
	rm "${ED}"/usr/bin/virt-list-partitions
	rm "${ED}"/usr/bin/virt-tar
	rm "${ED}"/usr/share/man/man1/virt-list-filesystems.1*
	rm "${ED}"/usr/share/man/man1/virt-list-partitions.1*
	rm "${ED}"/usr/share/man/man1/virt-tar.1*
}

pkg_postinst() {
	if ! use ocaml ; then
		einfo "Ocaml based tools (sysprep, ...) NOT installed"
	fi
	if ! use perl ; then
		einfo "Perl based tools NOT build"
	fi
}
