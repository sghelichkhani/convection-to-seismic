#!/bin/bash
#PBS -N vs_convert
#PBS -P xd2
#PBS -q normal
#PBS -l walltime=04:00:00
#PBS -l ncpus=1
#PBS -l mem=128GB
#PBS -l storage=scratch/xd2+gdata/xd2+gdata/fp50
#PBS -l wd
#PBS -j oe

set -euo pipefail

: "${NAME:?must pass -v NAME=<run-id>}"

source /scratch/xd2/rad552/FIREDRAKE_Simulations/GPlates/Cratons_M2/Seismic_Conversion/convection-to-seismic/pipeline_env.sh

INPUT_PVTU="${INPUT_PVTU:-${WORK}/${NAME}_output/output/output_0.pvtu}"
OUTPUT_VTU="${WORK}/${NAME}_converted.vtu"

[[ -f "${INPUT_PVTU}" ]] || { echo "ERROR: input pvtu not found: ${INPUT_PVTU}" >&2; exit 2; }

echo "[$(date)] Convert step starting for ${NAME}"
echo "[$(date)] Input : ${INPUT_PVTU}"
echo "[$(date)] Output: ${OUTPUT_VTU}"

python3 "${WORK}/convert_to_vs.py" "${INPUT_PVTU}" "${OUTPUT_VTU}"

[[ -f "${OUTPUT_VTU}" ]] || { echo "ERROR: expected output not created: ${OUTPUT_VTU}" >&2; exit 2; }

echo "[$(date)] Convert step complete."
