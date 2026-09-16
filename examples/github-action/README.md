# GitHub Action

This repository already uses the composite Action. See
[`.github/workflows/acid-judge.yml`](../../.github/workflows/acid-judge.yml).

```yaml
- uses: AleseyRodkin/acid-engine-2.0@v0.2.18
  with:
    index: locks/index.json
    judge: true
```

Default without `judge: true` is bind only. The `tamper` job must FAIL.
