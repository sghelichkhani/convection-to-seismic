#!/bin/bash
set -euo pipefail

WORK=/scratch/xd2/rad552/FIREDRAKE_Simulations/GPlates/Cratons_M2/Seismic_Conversion/convection-to-seismic
PY_PKGS="${WORK}/python-packages"

module use /g/data/fp50/modules
module load firedrake/2026.4.0
export PYTHONPATH="${PY_PKGS}:${PYTHONPATH:-}"
