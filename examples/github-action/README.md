# GitHub Action

This repository already uses the composite Action. See
[`.github/workflows/acid-judge.yml`](../../.github/workflows/acid-judge.yml).

```yaml
- uses: AleseyRodkin/acid-engine@v0.2.33
  with:
    index: locks/index.json
    judge: true
```

Default without `judge: true` is bind only. The `tamper` job must FAIL.
