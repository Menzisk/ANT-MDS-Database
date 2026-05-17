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
    "desmond_md_job_AbANT_Apigenin_trj/clickme.dtr",
    top="apigenin.pdb"
)

print(f"Loaded {traj.n_frames} frames, {traj.n_atoms} atoms")
traj.save_xtc("AbANT_apigenin_trajectory.xtc")
print("Saved: AbANT_apigenin_trajectory.xtc")

