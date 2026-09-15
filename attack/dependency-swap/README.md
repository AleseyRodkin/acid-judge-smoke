# Dependency swap

1. Lock `tools/with_dep/entry.py` (it imports `helper.py`).
2. Honest `judge` is PASS.
3. Rewrite `helper.py`. Do not touch `entry.py`.
4. `judge` against the original lock.
5. Observe FAIL.

Proves: static local import identity (`dep:`).
Does not prove: `importlib` / `exec` / `eval`.
