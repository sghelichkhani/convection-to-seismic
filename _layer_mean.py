"""Shared helper for layer-mean reduction on an extruded spherical-shell mesh.

The mesh used throughout this pipeline is extruded: every node sits on one of
a small number of discrete radii.  Combined with a quasi-uniform icosahedral
horizontal mesh (each surface node represents nearly equal area), the
unweighted nodal mean within a radial layer is a faithful approximation to
the area-weighted spherical-shell mean.  No cos(lat) weighting is needed at
this stage; weighting only becomes necessary if the mean is later recomputed
on a regular lon/lat grid.

`DEPTH_TOL` (km) controls how nodes are bucketed into layers — robust against
the ~1e-9 km floating-point spread that extrusion produces at a given
nominal radius, and small enough not to merge adjacent extrusion layers in
the configurations used here.
"""

import numpy as np

DEPTH_TOL = 1.0  # km


def dln_percent_by_layer(values, depth_km, tol=DEPTH_TOL):
    """Linearised seismological perturbation ``(V - <V>_z) / <V>_z * 100``.

    Nodes are grouped by depth rounded to ``tol`` km and ``<V>_z`` is the
    unweighted nodal mean within each layer.  NaN inputs are tolerated:
    `np.nanmean` is used for the layer reference, and NaN values map to
    NaN outputs without poisoning the rest of their layer.
    """
    rounded = np.round(np.asarray(depth_km) / tol) * tol
    values = np.asarray(values, dtype=np.float64)
    out = np.full(values.shape, np.nan, dtype=np.float64)
    for d in np.unique(rounded):
        mask = rounded == d
        mu = np.nanmean(values[mask])
        if not np.isfinite(mu) or mu == 0.0:
            continue
        out[mask] = (values[mask] - mu) / mu * 100.0
    return out
