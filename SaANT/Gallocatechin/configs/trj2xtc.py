# =============================================================
#  Converstion Script — "Name of System"
#  Section: Converts -trj folder into xtc for downstream analysis 
#  Author  : Menzi Sikakane
# =============================================================

import mdtraj as md

Conersion = "_trj to .xtc"

print("=" * 50)
print(f"   — {Conersion}")
print("=" * 50)

traj = md.load(
    "desmond_md_job_SaANT_Gallocatechin_trj/clickme.dtr",
    top="gallocatechin.pdb"
)

print(f"Loaded {traj.n_frames} frames, {traj.n_atoms} atoms")
traj.save_xtc("SaANT_Gallocatechin_trajectory.xtc")
print("Saved: SaANT_Gallocatechin_trajectory.xtc")

