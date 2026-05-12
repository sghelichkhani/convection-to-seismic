# Pipeline runs

All conversion .sh files are now generic over a run identifier `NAME`.  Each
run materialises as a set of files keyed by that name:

```
${NAME}_output/output/output_0.pvtu       staged simulation output
${NAME}_converted.vtu                     step 1 -> seismic velocities (+ dlnVs/dlnVp)
${NAME}_converted_srts_filtered.vtu       step 2 -> S12/S20/S40 RTS filtered
${NAME}_converted_tofi_filtered.vtu       step 3 -> LLNL-G3D-JPS filtered
${NAME}_converted{,_srts,_tofi}_filtered.nc   step 4 -> regridded NetCDF
```

## Active run names

| NAME                  | Source tarball                                                                                              | Notes                                        |
|-----------------------|-------------------------------------------------------------------------------------------------------------|----------------------------------------------|
| `C39_3e22_MuT`        | `/g/data/xd2/sg8812/kat-conversion-archive/0Ma_C39_3e22_MuT_Output.tar.gz`                                  | 0 Ma snapshot, 3e22 Pa s LM viscosity, MuT rheology |
| `Cratons2026_M1_C41`  | `/g/data/xd2/rad552/FIREDRAKE_Simulations/GPlates_Cratons_2026/Model_1/C41/output_vtk.tar.gz`               | rad552 GPlates_Cratons_2026 Model_1, case C41        |

## Submission

```bash
# Stage (skip if ${NAME}_output already exists on /scratch)
qsub -v NAME=C39_3e22_MuT,INPUT_TAR=/g/data/xd2/sg8812/kat-conversion-archive/0Ma_C39_3e22_MuT_Output.tar.gz 00_stage.sh

# Conversion chain
CONV=$(qsub -v NAME=C39_3e22_MuT 01_convert.sh)
SRTS=$(qsub -v NAME=C39_3e22_MuT -W depend=afterok:$CONV 02_srts_filter.sh)
TOFI=$(qsub -v NAME=C39_3e22_MuT -W depend=afterok:$CONV 03_tofi_filter.sh)
qsub -v NAME=C39_3e22_MuT -W depend=afterok:$SRTS:$TOFI 04_interpolate.sh
```

## Archive

Once a run has finished step 4, `archive.sh` tars its six artefacts
(`*.vtu` and `*.nc`) into `/g/data/xd2/sg8812/kat-conversion-archive/` as
`kat_${NAME}_artefacts_dlnV.tar.gz`.  The `_dlnV` suffix distinguishes the
current outputs (with dlnVs/dlnVp throughout) from the older `kat_*` legacy
tarballs that only contain absolute velocities.

```bash
qsub -v NAME=C39_3e22_MuT archive.sh
```

`README.md` in the archive directory documents the full layout and naming
convention.
