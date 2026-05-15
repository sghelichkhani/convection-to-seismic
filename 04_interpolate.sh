#!/bin/bash
#PBS -N interpolate
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

source ./pipeline_env.sh

PREFIX="${NAME}_converted"

BASE_VTU="${WORK}/${PREFIX}.vtu"
SRTS_VTU="${WORK}/${PREFIX}_srts_filtered.vtu"
TOFI_VTU="${WORK}/${PREFIX}_tofi_filtered.vtu"

BASE_NC="${WORK}/${PREFIX}.nc"
SRTS_NC="${WORK}/${PREFIX}_srts_filtered.nc"
TOFI_NC="${WORK}/${PREFIX}_tofi_filtered.nc"

[[ -f "${BASE_VTU}" ]] || { echo "ERROR: missing input ${BASE_VTU}" >&2; exit 2; }
[[ -f "${SRTS_VTU}" ]] || { echo "ERROR: missing input ${SRTS_VTU}" >&2; exit 2; }
[[ -f "${TOFI_VTU}" ]] || { echo "ERROR: missing input ${TOFI_VTU}" >&2; exit 2; }

interp() {
    local vtu="$1"
    local nc="$2"

    echo "[$(date)] Interpolating ${vtu} -> ${nc}"
    python3 -m ginterp.interp \
        "${vtu}" \
        --spherical \
        --radii 1.208,2.208 \
        --dims 360,181,129 \
        --output "${nc}"

    [[ -f "${nc}" ]] || { echo "ERROR: expected output not created: ${nc}" >&2; exit 2; }
}

echo "[$(date)] Interpolation step starting for ${NAME}"

interp "${BASE_VTU}" "${BASE_NC}"
interp "${SRTS_VTU}" "${SRTS_NC}"
interp "${TOFI_VTU}" "${TOFI_NC}"

echo "[$(date)] Interpolation step complete."
