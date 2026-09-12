---
# toolshed-xjek
title: 'validate.py crashes on a machine without beans: add_pass takes no detail'
status: completed
type: bug
priority: high
created_at: 2026-09-11T04:44:02Z
updated_at: 2026-09-11T04:44:45Z
---

`validate_beans_adapter_parity` calls `r.add_pass(name, detail)` at three sites (beans not installed, beans could not be asked, help text changed shape), but `Result.add_pass` takes only a name. On the GitHub runner beans is absent, so every push since the parity validator landed has failed CI with a TypeError before a single validator ran. Local runs never hit it because beans is installed here.

- [x] `Result.add_pass(name, detail="")`, printed as `✓ name (detail)`
- [x] test that runs the parity validator with `_beans.available()` False and gets a pass, not a crash

## Summary of Changes

`Result.add_pass(name, detail="")` renders `✓ name (detail)`. Two tests: the parity validator with `_beans.available()` patched False passes with a reason; `add_pass` with and without detail. Landed on `main` directly (bug, no feature parent).
