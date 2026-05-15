#!/bin/bash
set -euo pipefail

WORK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PY_PKGS="${WORK}/python-packages"

module use /g/data/fp50/modules
module load firedrake/2026.4.0

export WORK
export PY_PKGS
export PYTHONPATH="${PY_PKGS}:${PYTHONPATH:-}"
