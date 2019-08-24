# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit golang-build golang-vcs-snapshot bash-completion-r1

EGO_PN="github.com/openshift/origin"
OS_GIT_COMMIT="f6b4661ff60ce28254aaa2a2552479f5e32b1474"
OS_GIT_VERSION="v${PV}+${OS_GIT_COMMIT:0:7}-${PR#r}"
ARCHIVE_URI="https://github.com/openshift/origin/archive/${OS_GIT_COMMIT}.tar.gz -> openshift-origin-${OS_GIT_VERSION}.tar.gz"

KEYWORDS="~amd64"

DESCRIPTION="CLI to run commands against OpenShift clusters"
HOMEPAGE="https://github.com/openshift/origin https://okd.io"
SRC_URI="${ARCHIVE_URI}"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	!sys-cluster/kubectl
	!<sys-cluster/openshift-origin-${PV}
"

src_compile() {
	export OS_ONLY_BUILD_PLATFORMS="linux/amd64"
	export OS_GIT_COMMIT
	export OS_GIT_VERSION
	export OS_GIT_MAJOR="${PV%%.*}"
	export OS_GIT_MINOR="$(cut -d'.' -f2 <<< ${PV})"
	export OS_GIT_TREE_STATE="clean"

	# check Godeps/Godeps.json
	export KUBE_GIT_COMMIT="d4cacc043ac762235e16cb7361d527cb4189393c"
	export KUBE_GIT_VERSION="v1.11.0+${KUBE_GIT_COMMIT:0:7}"
	export KUBE_GIT_MAJOR="1"
	export KUBE_GIT_MINOR="11"

	# don't restrict go version
	export PERMISSIVE_GO=y

	LDFLAGS="" GOPATH="${WORKDIR}/${P}" emake -j1 -C src/${EGO_PN} WHAT=cmd/oc GOFLAGS=-v
	pushd src/${EGO_PN} || die
	_output/local/bin/linux/amd64/oc completion bash > oc.bash || die
	_output/local/bin/linux/amd64/oc completion zsh > oc.zsh || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin _output/local/bin/linux/amd64/oc
	dosym oc /usr/bin/kubectl

	newbashcomp oc.bash oc
	insinto /usr/share/zsh/site-functions
	newins oc.zsh _oc

	popd || die
}
