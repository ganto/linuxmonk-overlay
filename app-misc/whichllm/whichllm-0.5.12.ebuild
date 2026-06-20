# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="CLI tool to find the best local LLM for your hardware"
HOMEPAGE="
	https://github.com/Andyyyy64/whichllm
	https://pypi.org/project/whichllm/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/typer-0.9[${PYTHON_USEDEP}]
	>=dev-python/rich-13.0[${PYTHON_USEDEP}]
	>=dev-python/httpx-0.27[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.9[${PYTHON_USEDEP}]
	>=dev-python/dbgpu-1.0[${PYTHON_USEDEP},fuzz]
	>=dev-python/nvidia-ml-py-12.0[${PYTHON_USEDEP}]
"
