# Acid Judge Smoke Test

This repository demonstrates one property:

> An approved implementation must not silently become another
> implementation before execution.

It is not Acid Judge. The product is
[AleseyRodkin/acid-engine-2.0](https://github.com/AleseyRodkin/acid-engine-2.0).
This repo is a clean-clone proof.

No account. No SaaS. No API key.

## Run

```bash
git clone https://github.com/AleseyRodkin/acid-judge-smoke.git
cd acid-judge-smoke
./smoke.sh
```

`./attack-lab.sh` is the same proof with a name a security engineer will look for.

## Expected result

```text
ACID JUDGE SMOKE
────────────────────────────

1. Approved tool         PASS
2. Body tampering        BLOCKED
3. Dependency tampering  BLOCKED
4. Runtime tampering     BLOCKED
5. Receipt verification  PASS

All expected security properties reproduced.
```

## Attack

Protocols (what `./smoke.sh` actually does):

1. [attack/body-swap](attack/body-swap/README.md) — lock, change the formula, observe FAIL
2. [attack/dependency-swap](attack/dependency-swap/README.md) — lock, change `helper.py`, observe FAIL
3. [attack/runtime-swap](attack/runtime-swap/README.md) — poison `runtime_hashes` in the lock, observe FAIL

## What this proves

Implementation identity (body, static local import, judge contour) and that a
receipt can be signed locally.

## What this does not prove

Sandboxing. Business correctness. OS security. Shell outside `judge`.
site-packages. Environment variables.

## Examples

- [examples/plain-cli](examples/plain-cli/README.md)
- [examples/github-action](examples/github-action/README.md)
- [examples/claude-code](examples/claude-code/README.md)

Pinned to Acid Judge **v0.2.19**. PyPI name is `acid-judge` (`pip install acid-judge`). Import stays `acid_engine`.
