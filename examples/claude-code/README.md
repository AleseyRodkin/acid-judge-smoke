# Claude Code

The hook lives in Acid Judge, not here:

https://github.com/AleseyRodkin/acid-engine-2.0/blob/v0.2.13/examples/hooks/pre_tool_use.py

PreToolUse is bind only. Pre ≠ PASS. Point `ACID_LOCKS_INDEX` at this
repo's `locks/index.json` if you wire it into a checkout that also has
the product package installed.

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "compute_amount",
        "hooks": [{ "type": "command", "command": "python pre_tool_use.py" }]
      }
    ]
  }
}
```
