#!/usr/bin/env bash
# Clean-clone proof. Not a second Acid Judge. Not a sandbox.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
export PYTHONUNBUFFERED=1

TAG="${ACID_JUDGE_TAG:-v0.2.27}"
PIN="acid-judge @ git+https://github.com/AleseyRodkin/acid-engine.git@${TAG}"

aj() {
  python3 -m acid_engine "$@"
}

if ! python3 -c "import acid_engine" >/dev/null 2>&1; then
  python3 -m pip install -q "$PIN"
fi

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
mkdir -p "$ROOT/receipts" "$WORK/keys" "$WORK/dep" "$WORK/body"

cp tools/compute_amount.py "$WORK/body/compute_amount.py"
cp tools/with_dep/entry.py tools/with_dep/helper.py "$WORK/dep/"

fail() { echo "FAIL: $*" >&2; exit 1; }
ok() { printf "  %-24s %s\n" "$1" "$2"; }
blocked() { grep -q "Execution blocked" "$1"; }

echo
echo "ACID JUDGE SMOKE"
echo "────────────────────────────"
echo

# 1. Approved tool
out1="$WORK/approved.txt"
aj judge \
  --script tools/compute_amount.py \
  --plan tools/compute_amount.plan.json \
  --input '{"cents":199,"qty":3}' \
  --receipt "$ROOT/receipts/approved.json" \
  >"$out1" 2>&1 || true
grep -q "PASS" "$out1" || { cat "$out1"; fail "approved tool did not PASS"; }
ok "1. Approved tool" "PASS"

# 2. Body tampering
python3 - "$WORK/body/compute_amount.py" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
p.write_text(p.read_text().replace("cents * qty", "cents * qty * 2", 1))
PY
set +e
aj judge \
  --script "$WORK/body/compute_amount.py" \
  --plan tools/compute_amount.plan.json \
  --input '{"cents":199,"qty":3}' \
  --receipt "$ROOT/receipts/body-swap.json" \
  >"$WORK/body.txt" 2>&1
body_code=$?
set -e
blocked "$WORK/body.txt" || { cat "$WORK/body.txt"; fail "body swap was not blocked"; }
[ "$body_code" -ne 0 ] || fail "body swap exited 0"
ok "2. Body tampering" "BLOCKED"

# 3. Dependency tampering
(
  cd "$WORK/dep"
  aj lock --script entry.py --out entry.plan.json >/dev/null
)
set +e
(
  cd "$WORK/dep"
  aj judge --script entry.py --plan entry.plan.json --input '{"n":5}'
) >"$WORK/dep-ok.txt" 2>&1
dep_ok=$?
set -e
[ "$dep_ok" -eq 0 ] && grep -q "PASS" "$WORK/dep-ok.txt" || { cat "$WORK/dep-ok.txt"; fail "honest helper did not PASS"; }
printf '%s\n' 'def process(d):' '    return {"r": 3330}' > "$WORK/dep/helper.py"
set +e
(
  cd "$WORK/dep"
  aj judge --script entry.py --plan entry.plan.json --input '{"n":5}' \
    --receipt "$ROOT/receipts/dep-swap.json"
) >"$WORK/dep-bad.txt" 2>&1
dep_bad=$?
set -e
blocked "$WORK/dep-bad.txt" || { cat "$WORK/dep-bad.txt"; fail "helper swap was not blocked"; }
[ "$dep_bad" -ne 0 ] || fail "helper swap exited 0"
ok "3. Dependency tampering" "BLOCKED"

# 4. Runtime tampering
python3 - "$WORK/runtime.plan.json" <<'PY'
import json, sys
from pathlib import Path
raw = json.loads(Path("tools/compute_amount.plan.json").read_text())
rt = raw["toolchain"]["runtime_hashes"]
key = next(iter(rt))
rt[key] = "0" * 64
Path(sys.argv[1]).write_text(json.dumps(raw))
PY
set +e
aj judge \
  --script tools/compute_amount.py \
  --plan "$WORK/runtime.plan.json" \
  --input '{"cents":199,"qty":3}' \
  --receipt "$ROOT/receipts/runtime-swap.json" \
  >"$WORK/rt.txt" 2>&1
rt_code=$?
set -e
blocked "$WORK/rt.txt" || { cat "$WORK/rt.txt"; fail "runtime pin swap was not blocked"; }
[ "$rt_code" -ne 0 ] || fail "runtime pin swap exited 0"
ok "4. Runtime tampering" "BLOCKED"

# 5. Receipt verification (local Ed25519, not Sigstore)
aj receipt --keygen --out-dir "$WORK/keys" >/dev/null
aj receipt --sign "$ROOT/receipts/approved.json" --key "$WORK/keys/ed25519.secret.pem" \
  --out "$ROOT/receipts/approved.sig.json" >/dev/null
aj receipt --verify "$ROOT/receipts/approved.json" \
  --sig "$ROOT/receipts/approved.sig.json" \
  --pubkey "$WORK/keys/ed25519.public.pem" >/dev/null
python3 - <<'PY'
import json
from pathlib import Path
rec = json.loads(Path("receipts/approved.json").read_text())
assert rec["verdict"]["status"] == "PASS"
assert "proven_pure" not in json.dumps(rec)
PY
ok "5. Receipt verification" "PASS"

echo
echo "All expected security properties reproduced."
echo "No account. No SaaS. No API key."
echo
