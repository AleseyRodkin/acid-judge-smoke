# acid-judge-smoke

Foreign-repo check for [Acid Judge](https://github.com/AleseyRodkin/acid-engine-2.0) **v0.2.5**.

- `lock` job: bind + judge + receipt (`judge: true`)
- `tamper` job: swapped body must FAIL

Not a sandbox. Not MCP. Same GitHub account as the engine.

```yaml
- uses: AleseyRodkin/acid-engine-2.0@v0.2.5
  with:
    index: locks/index.json
    judge: true
```
