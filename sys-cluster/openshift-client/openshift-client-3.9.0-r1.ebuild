# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit golang-build golang-vcs-snapshot bash-completion-r1

EGO_PN="github.com/openshift/origin"
ARCHIVE_URI="https://github.com/openshift/origin/archive/v${PV}.tar.gz -> openshift-origin-${PV}.tar.gz"
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
	export OS_GIT_COMMIT="191fece9305a76f262baacc9de72c2c8cb4d5601"
	export OS_GIT_VERSION="v${PV}-${OS_GIT_COMMIT:0:7}"
	export OS_GIT_MAJOR="${PV%%.*}"
	export OS_GIT_MINOR="$(cut -d'.' -f2 <<< ${PV})"
	export OS_GIT_TREE_STATE="clean"

	# check Godeps/Godeps.json
	export KUBE_GIT_COMMIT="a0ce1bc657faa48c85731dcca6a613d91224dea0"
	export KUBE_GIT_VERSION="v1.9.1-${KUBE_GIT_COMMIT:0:10}"

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
