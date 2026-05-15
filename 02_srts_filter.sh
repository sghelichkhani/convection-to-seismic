#!/bin/bash
#PBS -N srts_filter
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

source ./pipeline_env.sh

INPUT_VTU="${WORK}/${NAME}_converted.vtu"
OUTPUT_VTU="${WORK}/${NAME}_converted_srts_filtered.vtu"

[[ -f "${INPUT_VTU}" ]] || { echo "ERROR: input vtu not found: ${INPUT_VTU}" >&2; exit 2; }

echo "[$(date)] S-RTS filter step starting for ${NAME}"
echo "[$(date)] Input : ${INPUT_VTU}"
echo "[$(date)] Output: ${OUTPUT_VTU}"

python3 "${WORK}/srts_filter.py" "${INPUT_VTU}"

[[ -f "${OUTPUT_VTU}" ]] || { echo "ERROR: expected output not created: ${OUTPUT_VTU}" >&2; exit 2; }

echo "[$(date)] S-RTS filter step complete."
