---
# toolshed-123h
title: status.py contradicts FIELD_SCHEMA on the brief status field
status: todo
type: bug
priority: normal
created_at: 2026-09-11T00:14:01Z
updated_at: 2026-09-11T00:14:01Z
---

`/adjudant status` reports `status-off-vocabulary` on every brief that omits `status:`, and the schema forbids the field being there.

## The contradiction, three sources

- `reference/vault-standards.md` line 47: "there is no `status:` field on a brief. Moves happen through the guided triage in /adjudant status."
- `_vault_walk.FIELD_SCHEMA['project']`: required is {type, created, updated, verified, verified_by}, **optional is an empty frozenset**. A `status` key is therefore an unknown field and `schema_drift_for_text` flags it.
- `status.py:1081`: appends `status-off-vocabulary` to **wrong_now** when `declared_valid is False`, which is exactly what a spec-compliant brief produces.

A compliant brief cannot satisfy both. Add the field and `schema_drift` flags it. Omit it and `status-off-vocabulary` fires.

## Evidence from this vault

Measured across Claude Cabinet, 2026-09-10: 20 of 21 project briefs carry `status: active`, so 20 of them are carrying a retired field and every one is in schema drift. Only `toolshed` is compliant, and it is the one the checker complains about.

## Likely fix

Retire the `status-off-vocabulary` check, or gate it on a brief that actually declares a status. The zone folder is the lifecycle state now, per the standards file.

## Todo

- [ ] Decide whether the check or the schema is the survivor
- [ ] If the check goes: delete the `status-off-vocabulary` branch and its test
- [ ] Sweep the 20 legacy briefs, or leave them and exempt legacy keys deliberately
- [ ] Note the decision in vault-standards so the next reader does not re-litigate it
