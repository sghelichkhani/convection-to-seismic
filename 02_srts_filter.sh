#!/bin/bash
#PBS -N srts_filter
#PBS -P xd2
#PBS -q normal
#PBS -l walltime=02:00:00
#PBS -l ncpus=1
#PBS -l mem=64GB
#PBS -l storage=scratch/xd2+gdata/fp50
#PBS -l wd
#PBS -j oe

# Step 2: S12/S20/S40 RTS tomographic filtering.
#
# Pass via qsub -v:
#   NAME  run identifier (required); input is ${WORK}/${NAME}_converted.vtu

set -euo pipefail

: "${NAME:?must pass -v NAME=<run-id>}"

WORK=/scratch/xd2/sg8812/kat-conversion
INPUT_VTU="${WORK}/${NAME}_converted.vtu"

module use /g/data/fp50/modules
module load firedrake/main-20260417
export PYTHONPATH=/scratch/xd2/sg8812/g-drift:/scratch/xd2/sg8812/local/lib/python3.11/site-packages:${PYTHONPATH:-}

echo "[$(date)] S-RTS filtering ${INPUT_VTU}"
python3 "${WORK}/srts_filter.py" "${INPUT_VTU}"
echo "[$(date)] Done."
