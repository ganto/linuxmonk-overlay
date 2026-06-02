# keepass-diff

## Version 1.2.0 — missing GitHub tag

The author published keepass-diff 1.2.0 directly to crates.io on 2023-11-06 **without creating a
corresponding git tag** in the GitHub repository
(<https://github.com/Narigo/keepass-diff>). The latest tag there is `1.1.3`.

The crates.io release is nonetheless verifiable: the crate archive contains
`.cargo_vcs_info.json` which records the exact source commit:

```
08344c5c1d91dd6095af9b3e854bd453278a018c
```

This commit exists on the GitHub `master` branch and was authored by the
project owner (Joern Bernhardt). It is the result of merging PR #66
("mask-passwords") followed by a `cargo fmt` pass.

## Changes between 1.1.3 and 1.2.0

### New feature: `--mask-passwords` / `-m`

Protected fields (i.e. actual passwords) are shown as `***` in the diff
output when this flag is passed. The flag is threaded through the full
rendering stack (`main` → `Group` → `Entry` → `Field`).

### Dependency updates

| Crate | 1.1.3 | 1.2.0 | Notes |
|-------|-------|-------|-------|
| `keepass` | 0.4.9 | 0.6.6 | New `keepass::db::*` module layout; `DatabaseKey` builder API |
| `clap` | 3.0.10 | 4.4.7 | |
| `rpassword` | 5.0.1 | 7.2.0 | `prompt_password_stdout()` → `prompt_password()` |
| `base64` | — | 0.21.5 | New dep; binary fields are now base64-encoded in output |

### Bug fixes (included in the commit range)

- Entries without a `Title` field no longer cause a panic.
- Color reset is now done via `stdout.reset()` once after rendering instead
  of `set_fg(None)` at multiple call sites.
- Docker build fixed.
