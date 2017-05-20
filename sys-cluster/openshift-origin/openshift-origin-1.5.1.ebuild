# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1 systemd

GIT_COMMIT=7b451fc9cade386042723a2c03c2deee626b579c

DESCRIPTION="Enterprise Kubernetes for Developers"
HOMEPAGE="https://openshift.org"
SRC_URI="https://github.com/openshift/origin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	sys-apps/systemd
	!!sys-cluster/kubectl
	net-misc/rsync
"
DEPEND="${COMMON_DEPEND}
	app-crypt/mit-krb5
	>=dev-lang/go-1.6.2
"
RDEPEND="${COMMON_DEPEND}
	>=app-emulation/docker-1.9.1
	dev-vcs/git
	net-firewall/iptables
	net-fs/nfs-utils
	net-misc/socat
	sys-apps/ethtool
	sys-apps/util-linux
"

PATCHES=( "${FILESDIR}/origin-1.5.0-platform-compile.patch" )

S="${WORKDIR}/origin-${PV}"

src_compile() {
	export OS_ONLY_BUILD_PLATFORMS="linux/amd64"
	export OS_GIT_VERSION="v${PV}"
	export OS_GIT_COMMIT="${GIT_COMMIT}"
	export OS_GIT_MAJOR="${PV%%.*}"
	export OS_GIT_MINOR="$(cut -d'.' -f2 <<< ${PV})"
	export OS_GIT_TREE_STATE="clean"
	hack/build-cross.sh || die "Building binaries failed."
	hack/generate-docs.sh || die "Building man-pages failed."
}

src_install() {
	PLATFORM="$(go env GOHOSTOS)/$(go env GOHOSTARCH)"

	# Install linux components
	for bin in oc openshift dockerregistry pod; do
		dobin _output/local/bin/${PLATFORM}/${bin}
	done

	for cmd in \
		atomic-enterprise \
		kube-apiserver \
		kube-controller-manager \
		kube-proxy \
		kube-scheduler \
		kubelet \
		kubernetes \
		oadm \
		openshift-deploy \
		openshift-docker-build \
		openshift-f5-router \
		openshift-recycle \
		openshift-router \
		openshift-sti-build \
		origin
	do
		dosym openshift /usr/bin/${cmd}
	done
	dosym oc /usr/bin/kubectl

	dodir /etc/origin/{master,node}

	insinto /etc/sysconfig
	newins contrib/systemd/origin-master.sysconfig origin-master
	newins contrib/systemd/origin-node.sysconfig origin-node

	systemd_dounit contrib/systemd/origin-master.service
	systemd_dounit contrib/systemd/origin-node.service

	doman docs/man/man1/*

	# Install sdn scripts
	insinto /etc/cni/net.d
	doins pkg/sdn/plugin/sdn-cni-plugin/80-openshift-sdn.conf
	dobin pkg/sdn/plugin/bin/openshift-sdn-ovs
	exeinto /opt/cni/bin
	for exe in sdn-cni-plugin host-local loopback; do
		doexe _output/local/bin/${PLATFORM}/${exe}
	done
	insinto "$(systemd_get_systemunitdir)/origin-node.service.d"
	doins contrib/systemd/openshift-sdn-ovs.conf

	# Install bash-completion
	for bin in oadm oc openshift atomic-enterprise; do
		"${D}"/usr/bin/${bin} completion bash > ${bin}.bash_completion
		newbashcomp ${bin}.bash_completion ${bin}
	done

	# Install origin-accounting
	insinto /etc/systemd/system.conf.d
	doins contrib/systemd/origin-accounting.conf
}

pkg_postinst() {
	elog "When starting the OpenShift master for the first time, run:"
	elog "  openshift start master --write-config=/etc/origin/master"
	elog
	elog "To create a node configuration run the following command on the OpenShift master:"
	elog "  oadm create-node-config --node-dir=/etc/origin/node/ \\"
	elog "                          --node=localhost --hostnames=localhost,127.0.0.1 \\"
	elog "                          --node-client-certificate-authority=/etc/origin/master/ca.crt \\"
	elog "                          --signer-cert=/etc/origin/master/ca.crt \\"
	elog "                          --signer-key=/etc/origin/master/ca.key \\"
	elog "                          --signer-serial=/etc/origin/master/ca.serial.txt \\"
	elog "                          --certificate-authority=/etc/origin/master/ca.crt"
}
