#!/bin/bash
#PBS -N vs_convert
#PBS -P xd2
#PBS -q normal
#PBS -l walltime=04:00:00
#PBS -l ncpus=1
#PBS -l mem=128GB
#PBS -l storage=scratch/xd2+gdata/fp50
#PBS -l wd
#PBS -j oe

# Step 1: Convert mantle convection output (pvtu) to seismic velocities.
#
# Pass via qsub -v:
#   NAME        run identifier (required)
#   INPUT_PVTU  optional override; defaults to ${WORK}/${NAME}_output/output/output_0.pvtu
#
# Output: ${WORK}/${NAME}_converted.vtu

set -euo pipefail

: "${NAME:?must pass -v NAME=<run-id>}"

WORK=/scratch/xd2/sg8812/kat-conversion
INPUT_PVTU="${INPUT_PVTU:-${WORK}/${NAME}_output/output/output_0.pvtu}"
OUTPUT_VTU="${WORK}/${NAME}_converted.vtu"

module use /g/data/fp50/modules
module load firedrake/main-20260417
export PYTHONPATH=/scratch/xd2/sg8812/g-drift:/scratch/xd2/sg8812/local/lib/python3.11/site-packages:${PYTHONPATH:-}

echo "[$(date)] Converting ${INPUT_PVTU} -> ${OUTPUT_VTU}"
python3 "${WORK}/convert_to_vs.py" "${INPUT_PVTU}" "${OUTPUT_VTU}"
echo "[$(date)] Done."
