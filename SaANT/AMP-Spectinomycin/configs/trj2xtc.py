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
    "desmond_md_job_Sa_AMP_Spectinomycin_trj/clickme.dtr",
    top="ampspectinomycin.pdb"
)

print(f"Loaded {traj.n_frames} frames, {traj.n_atoms} atoms")
traj.save_xtc("Sa_AMP_Spectinomycin_trajectory.xtc")
print("Saved: Sa_AMP_Spectinomycin_trajectory.xtc")

