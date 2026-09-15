# Body swap

1. Lock `tools/compute_amount.py` (already in git as `tools/compute_amount.plan.json`).
2. Change `cents * qty` to `cents * qty * 2`.
3. `judge` against the original lock.
4. Observe FAIL. The body does not run.

Proves: implementation identity of the tool file.
