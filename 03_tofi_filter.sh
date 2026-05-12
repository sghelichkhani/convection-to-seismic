#!/bin/bash
#PBS -N tofi_filter
#PBS -P xd2
#PBS -q normal
#PBS -l walltime=02:00:00
#PBS -l ncpus=1
#PBS -l mem=64GB
#PBS -l storage=scratch/xd2+gdata/xd2+gdata/fp50
#PBS -l wd
#PBS -j oe

set -euo pipefail

: "${NAME:?must pass -v NAME=<run-id>}"

source /scratch/xd2/rad552/FIREDRAKE_Simulations/GPlates/Cratons_M2/Seismic_Conversion/convection-to-seismic/pipeline_env.sh

INPUT_VTU="${WORK}/${NAME}_converted.vtu"
OUTPUT_VTU="${WORK}/${NAME}_converted_tofi_filtered.vtu"

[[ -f "${INPUT_VTU}" ]] || { echo "ERROR: input vtu not found: ${INPUT_VTU}" >&2; exit 2; }

echo "[$(date)] TOFI filter step starting for ${NAME}"
echo "[$(date)] Input : ${INPUT_VTU}"
echo "[$(date)] Output: ${OUTPUT_VTU}"

python3 "${WORK}/tofi_filter.py" "${INPUT_VTU}" "${OUTPUT_VTU}"

[[ -f "${OUTPUT_VTU}" ]] || { echo "ERROR: expected output not created: ${OUTPUT_VTU}" >&2; exit 2; }

echo "[$(date)] TOFI filter step complete."
