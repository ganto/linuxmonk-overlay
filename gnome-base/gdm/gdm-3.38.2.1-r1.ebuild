# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop gnome.org gnome2-utils meson pam readme.gentoo-r1 systemd udev xdg

DESCRIPTION="GNOME Display Manager for managing graphical display servers and user logins"
HOMEPAGE="https://wiki.gnome.org/Projects/GDM"

SRC_URI="${SRC_URI}
	branding? ( https://www.mail-archive.com/tango-artists@lists.freedesktop.org/msg00043/tango-gentoo-v1.1.tar.gz )
"

LICENSE="
	GPL-2+
	branding? ( CC-BY-SA-4.0 )
"

SLOT="0"

IUSE="accessibility audit bluetooth-sound branding fprint +introspection ipv6 plymouth selinux smartcard tcpd test wayland"
RESTRICT="!test? ( test )"

KEYWORDS="~amd64"

# NOTE: x11-base/xorg-server dep is for X_SERVER_PATH etc, bug #295686
# nspr used by smartcard extension
# dconf, dbus and g-s-d are needed at install time for dconf update
# keyutils is automagic dep that makes autologin unlock login keyring when all the passwords match (disk encryption, user pw and login keyring)
# dbus-run-session used at runtime
COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.44:2
	dev-libs/libgudev
	>=x11-libs/gtk+-2.91.1:3
	>=gnome-base/dconf-0.20
	>=gnome-base/gnome-settings-daemon-3.28
	gnome-base/gsettings-desktop-schemas
	>=media-libs/fontconfig-2.5.0:1.0
	>=media-libs/libcanberra-0.4[gtk3]
	sys-apps/dbus
	>=sys-apps/accountsservice-0.6.35

	x11-base/xorg-server
	x11-libs/libXau
	x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libxcb
	>=x11-misc/xdg-utils-1.0.2-r3

	sys-libs/pam
	sys-apps/keyutils:=
	>=sys-apps/systemd-186:0=[pam]

	sys-auth/pambase[systemd]

	audit? ( sys-process/audit )
	introspection? ( >=dev-libs/gobject-introspection-0.9.12:= )
	plymouth? ( sys-boot/plymouth )
	selinux? ( sys-libs/libselinux )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
"
# XXX: These deps are from session and desktop files in data/ directory
# fprintd is used via dbus by gdm-fingerprint-extension
# gnome-session-3.6 needed to avoid freezing with orca
RDEPEND="${COMMON_DEPEND}
	acct-group/gdm
	acct-user/gdm
	>=gnome-base/gnome-session-3.6
	>=gnome-base/gnome-shell-3.1.90
	x11-apps/xhost

	accessibility? (
		>=app-accessibility/orca-3.10
		gnome-extra/mousetweaks )
	fprint? ( sys-auth/fprintd[pam] )
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=gnome-base/dconf-0.20
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( >=dev-libs/check-0.9.4 )
	app-text/yelp-tools
" # yelp-tools needed for eautoreconf to not lose help docs (m4_ifdeffed YELP_HELP_INIT call and setup)

DOC_CONTENTS="
	To make GDM start at boot with systemd, run:\n
	# systemctl enable gdm.service\n
	\n
	To make GDM start at boot with OpenRC, edit /etc/conf.d to have
	DISPLAYMANAGER=\"gdm\" and enable the xdm service:\n
	# rc-update add xdm
	\n
	For passwordless login to unlock your keyring, you need to install
	sys-auth/pambase with USE=gnome-keyring and set an empty password
	on your keyring. Use app-crypt/seahorse for that.\n
	\n
	You may need to install app-crypt/coolkey and sys-auth/pam_pkcs11
	for smartcard support
"

src_prepare() {
	default

	# ssh-agent handling must be done at xinitrc.d, bug #220603
	eapply "${FILESDIR}/${PN}-2.32.0-xinitrc-ssh-agent.patch"

	# Gentoo does not have a fingerprint-auth pam stack
	eapply "${FILESDIR}/${PN}-3.8.4-fingerprint-auth.patch"

	# Show logo when branding is enabled
	use branding && eapply "${FILESDIR}/${PN}-3.30.3-logo.patch"
}

src_configure() {
	# -Dat-spi-registryd-dir= needs to be passed explicitly because
	# of https://bugzilla.gnome.org/show_bug.cgi?id=607643#c4
	local emesonargs=(
		-Dat-spi-registryd-dir="${EPREFIX}"/usr/libexec
		-Ddefault-pam-config=exherbo
		-Dgdm-xsession=true
		$(meson_use ipv6)
		$(meson_feature audit libaudit)
		-Dpam-mod-dir=$(getpam_mod_dir)
		$(meson_feature plymouth)
		-Drun-dir=/run/gdm
		$(meson_feature selinux)
		-Dsystemd-journal=true
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
		$(meson_use tcpd tcp-wrappers)
		-Dudev-dir=$(get_udevdir)/rules.d
		-Duser-display-server=true
		$(meson_use wayland wayland-support)
		-Dworking-dir=/var/lib/gdm
		-Dxdmcp=enabled
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	if ! use accessibility ; then
		rm "${ED}"/usr/share/gdm/greeter/autostart/orca-autostart.desktop || die
	fi

	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}/49-keychain-r1" 49-keychain
	newexe "${FILESDIR}/50-ssh-agent-r1" 50-ssh-agent

	if ! use bluetooth-sound ; then
		# Workaround https://gitlab.freedesktop.org/pulseaudio/pulseaudio/merge_requests/10
		# bug #679526
		insinto /var/lib/gdm/.config/pulse
		doins "${FILESDIR}"/default.pa
	fi

	# install XDG_DATA_DIRS gdm changes
	echo 'XDG_DATA_DIRS="/usr/share/gdm"' > 99xdg-gdm
	doenvd 99xdg-gdm

	use branding && newicon "${WORKDIR}/tango-gentoo-v1.1/scalable/gentoo.svg" gentoo-gdm.svg

	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	local d ret
	# bug #669146; gdm may crash if /var/lib/gdm subdirs are not owned by gdm:gdm
	ret=0
	ebegin "Fixing "${EROOT}"/var/lib/gdm ownership"
	chown --no-dereference gdm:gdm "${EROOT}/var/lib/gdm" || ret=1
	for d in "${EROOT}/var/lib/gdm/"{.cache,.color,.config,.dbus,.local}; do
		[[ ! -e "${d}" ]] || chown --no-dereference -R gdm:gdm "${d}" || ret=1
	done
	eend ${ret}

	systemd_reenable gdm.service
	readme.gentoo_print_elog
}