#!/usr/bin/env python3
"""
Generate the ZBS_DEPENDENCIES bash associative-array declaration for herdr's
vendored libghostty-vt Zig dependencies, derived from build.zig.zon.json in
the extracted source tree.  The output is ready to paste into the ebuild
before `inherit zig` (ZBS_DEPENDENCIES is @PRE_INHERIT).

Usage:
    python3 gen-zig-deps.py /path/to/herdr-<PV>/vendor/libghostty-vt/build.zig.zon.json

Output goes to stdout; redirect as needed when updating the ebuild.

Key format follows x11-terms/ghostty convention: bare Zig package hash +
extension (e.g. "N-V-__8AAB0e....tar.gz") so distfiles are content-identical
to ghostty's and share the same DISTDIR entries.
"""

import json
import re
import sys
import urllib.parse


def git_url_to_tarball(url: str) -> str | None:
    """Convert git+https://github.com/<owner>/<repo>#<commit> to a tarball URL."""
    m = re.match(r"git\+https://github\.com/([^/]+/[^#]+)#([0-9a-f]+)$", url)
    if m:
        return f"https://github.com/{m.group(1)}/archive/{m.group(2)}.tar.gz"
    return None


def pkg_ext(url: str) -> str:
    """Return the archive extension for a URL."""
    path = urllib.parse.urlparse(url).path
    for ext in (".tar.gz", ".tar.zst", ".tar.xz", ".tgz"):
        if path.endswith(ext):
            return ext
    return ".tar.gz"


def main(json_path: str) -> None:
    data = json.load(open(json_path))

    # Build list of (key, url) pairs — key = "<zighash><ext>" (ghostty-style)
    entries: list[tuple[str, str]] = []

    for pkg_hash, pkg in data.items():
        url = pkg.get("url", "")
        if not url:
            continue

        # Convert git+https:// URLs to GitHub archive tarballs
        if url.startswith("git+"):
            tarball_url = git_url_to_tarball(url)
            if tarball_url is None:
                print(f"# WARNING: cannot convert git URL: {url}", file=sys.stderr)
                continue
            url = tarball_url

        if not url.startswith("http"):
            continue  # skip path-based / local deps

        ext = pkg_ext(url)
        key = f"{pkg_hash}{ext}"
        entries.append((key, url))

    print("declare -g -r -A ZBS_DEPENDENCIES=(")
    for key, url in sorted(entries):
        print(f"\t[{key}]='{url}'")
    print(")")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <path-to-build.zig.zon.json>", file=sys.stderr)
        sys.exit(1)
    main(sys.argv[1])
