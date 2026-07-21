#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ANCHORS="${ROOT}/config/release_anchors_task23_v153_no_final_anchor.json"
TARGETS="${ROOT}/config/tasks2_26_endpose_targets_seed100_199_no_task23_placepopcorn.json"
LAUNCHER="${ROOT}/run_task23_v153.sh"

jq -e '
  .tasks["23"] | length == 2 and
  all(.[]; .released != "pick popcorn" and .next != "place popcorn")
' "${ANCHORS}" >/dev/null
jq -e '(.tasks["23"].subtasks | has("place popcorn")) | not' "${TARGETS}" >/dev/null
rg -q 'release_anchors_task23_v153_no_final_anchor\.json' "${LAUNCHER}"
rg -q 'RUN_ID="\$\{RUN_ID:-task23_v153_v145_no_placepopcorn_no_final_anchor\}"' "${LAUNCHER}"

echo 'PASS: v153 has exactly two anchors and no place-popcorn target/anchor'
