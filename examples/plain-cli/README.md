# Plain CLI

```bash
pip install acid-judge
# from git, same metadata name:
# pip install "acid-judge @ git+https://github.com/AleseyRodkin/acid-engine-2.0.git@v0.2.20"
acid-judge judge \
  --script tools/compute_amount.py \
  --plan tools/compute_amount.plan.json \
  --input '{"cents":199,"qty":3}'
```

Without `--plan` the verdict is SKIPPED, not PASS.
