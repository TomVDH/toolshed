---
# toolshed-iqae
title: 'CI on Linux: 5 tests fail that pass on macOS'
status: todo
type: bug
priority: normal
created_at: 2026-09-11T04:47:07Z
updated_at: 2026-09-11T04:47:07Z
---

Now that `validate.py` no longer crashes on the runner (toolshed-xjek), the GitHub Action reaches the unit tests and 5 fail on ubuntu that pass locally:

- `test_status.TestCLI.test_scan_emits_json_and_writes_nothing`, `test_scan_of_a_tidy_project_says_so`, `TestCheckCost.test_normal_run_includes_cost`, `TestSitrepCost.test_normal_run_includes_cost`: `PermissionError: /proc/1046/map_files`. `run()` derives `vault_root` from `project_dir.parent.parent.parent` when no vault is given; for a temp dir three levels up is `/`, and `build_vault_index` walks it. On macOS `/` walks fine; on Linux it hits `/proc`. Fix: refuse a derived vault root that is `/` or `$TMPDIR`'s parent, or have the CLI tests pass a vault.
- `test__agents_reach.TestPrecisionBeatsRecall.test_this_repo_own_agents_md_reports_nothing_missing`: toolshed `AGENTS.md` names `~/Library/Mobile Documents/.../install-hookify-rules.sh`, which does not exist on the runner. Fix: skip `~/Library` paths in the reach check, or mark the test macOS-only.

Runs: https://github.com/TomVDH/toolshed/actions/runs/34563357353 (main), 34563364772 (PR #5).

- [ ] vault-root derivation never walks `/`
- [ ] agents-reach ignores or skips home-relative macOS paths on Linux
- [ ] validate.yml green on push
