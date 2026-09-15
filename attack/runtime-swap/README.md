# Runtime swap

1. Copy `tools/compute_amount.plan.json`.
2. Replace one `runtime_hashes` value with zeros.
3. `judge` the honest tool against the poisoned lock.
4. Observe FAIL.

Proves: the judge contour is pinned (`worker.py` and the rest of `runtime_hashes`).
The body is unchanged. The lock is not.
