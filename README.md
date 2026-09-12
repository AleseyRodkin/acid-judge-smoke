# acid-judge-smoke

Foreign-repo check for [Acid Judge](https://github.com/AleseyRodkin/acid-engine-2.0).
One tool. The Action binds live bytes to `plan.lock`. Tamper job must FAIL.
Not a sandbox. Not MCP.

```yaml
- uses: AleseyRodkin/acid-engine-2.0@v0.2.2
  with:
    index: locks/index.json
```
