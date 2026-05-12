#!/bin/bash
#PBS -N stage
#PBS -P xd2
#PBS -q copyq
#PBS -l walltime=04:00:00
#PBS -l ncpus=1
#PBS -l mem=8GB
#PBS -l storage=scratch/xd2+gdata/xd2+gdata/fp50
#PBS -l wd
#PBS -j oe

set -euo pipefail

: "${NAME:?must pass -v NAME=<run-id>}"
: "${INPUT_TAR:?must pass -v INPUT_TAR=<path/to/tarball>}"

source /scratch/xd2/rad552/FIREDRAKE_Simulations/GPlates/Cratons_M2/Seismic_Conversion/convection-to-seismic/pipeline_env.sh

UNTAR_DIR="${WORK}/${NAME}_output"
PVTU="${UNTAR_DIR}/output/output_0.pvtu"

cd "${WORK}"

[[ -f "${INPUT_TAR}" ]] || { echo "ERROR: input tarball not found: ${INPUT_TAR}" >&2; exit 2; }

echo "[$(date)] Staging run: ${NAME}"
echo "[$(date)] Untarring ${INPUT_TAR} into ${UNTAR_DIR}"

mkdir -p "${UNTAR_DIR}"
tar xzf "${INPUT_TAR}" -C "${UNTAR_DIR}"

echo "[$(date)] Listing pvd and pvtu files:"
find "${UNTAR_DIR}" -maxdepth 3 \( -name "*.pvd" -o -name "*.pvtu" \)

[[ -f "${PVTU}" ]] || { echo "ERROR: expected pvtu not found at ${PVTU}" >&2; exit 2; }

echo "[$(date)] pvtu confirmed at: ${PVTU}"
echo "[$(date)] Field names in pvtu:"
grep -o 'Name="[^"]*"' "${PVTU}" | sort -u

echo "[$(date)] Stage step complete."
