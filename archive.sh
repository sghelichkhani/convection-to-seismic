#!/bin/bash
#PBS -N archive
#PBS -P xd2
#PBS -q copyq
#PBS -l walltime=04:00:00
#PBS -l ncpus=1
#PBS -l mem=8GB
#PBS -l storage=scratch/xd2+gdata/xd2
#PBS -l wd
#PBS -j oe

# Archive a runs six pipeline artefacts to /g/data.
#
# Pass via qsub -v:
#   NAME  run identifier (required) - same NAME used by 01-04 jobs
#
# Output:
#   /g/data/xd2/sg8812/kat-conversion-archive/kat_${NAME}_artefacts_dlnV.tar.gz
#
# The "_dlnV" suffix marks the post-2026-05 outputs which carry dlnVs/dlnVp
# fields throughout, distinguishing them from older artefact tarballs that
# only contain absolute Vs/Vp.

set -euo pipefail

: "${NAME:?must pass -v NAME=<run-id>}"

WORK=/scratch/xd2/sg8812/kat-conversion
ARCHIVE_DIR=/g/data/xd2/sg8812/kat-conversion-archive
ARCHIVE="${ARCHIVE_DIR}/kat_${NAME}_artefacts_dlnV.tar.gz"

mkdir -p "${ARCHIVE_DIR}"
cd "${WORK}"

FILES=(
    "${NAME}_converted.vtu"
    "${NAME}_converted.nc"
    "${NAME}_converted_srts_filtered.vtu"
    "${NAME}_converted_srts_filtered.nc"
    "${NAME}_converted_tofi_filtered.vtu"
    "${NAME}_converted_tofi_filtered.nc"
)

for f in "${FILES[@]}"; do
    if [[ ! -f "$f" ]]; then
        echo "[$(date)] ERROR: missing $f" >&2
        exit 2
    fi
done

echo "[$(date)] Tarring ${#FILES[@]} files to ${ARCHIVE}"
tar czf "${ARCHIVE}" "${FILES[@]}"

echo "[$(date)] Archive size:"
ls -lh "${ARCHIVE}"

echo "[$(date)] Verifying contents:"
tar tzf "${ARCHIVE}"

echo "[$(date)] Done. Originals retained in ${WORK}."
