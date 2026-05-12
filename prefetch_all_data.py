import gdrift
import gdrift.io
import llnltofi
from srts import S12RTS, S20RTS, S40RTS

print("=== Prefetch: gdrift ===")
print("gdrift data path:", gdrift.io.DATA_PATH)
gdrift.download_all_datasets()
print("gdrift datasets downloaded.")

print("\n=== Prefetch: llnltofi ===")
model = llnltofi.ResolutionModel()
_ = model.coordinates_in_lonlatdepth
_ = model.coordinates_in_xyz
_ = model.R
print("llnltofi coordinates_in_lonlatdepth shape:", model.coordinates_in_lonlatdepth.shape)
print("llnltofi coordinates_in_xyz shape:", model.coordinates_in_xyz.shape)
print("llnltofi R shape:", model.R.shape)
print("llnltofi datasets downloaded.")

print("\n=== Prefetch: srts ===")
for cls, name in [(S12RTS, "S12RTS"), (S20RTS, "S20RTS"), (S40RTS, "S40RTS")]:
    m = cls()
    ref = m.reference_model
    print(f"{name} reference_model shape: {ref.shape}")

print("\nAll downloads complete.")
