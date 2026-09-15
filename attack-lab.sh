#!/usr/bin/env bash
# Same three properties as smoke.sh, with receipts left in attack/.
# Not 20 CVEs. Not a second product.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"
exec ./smoke.sh
