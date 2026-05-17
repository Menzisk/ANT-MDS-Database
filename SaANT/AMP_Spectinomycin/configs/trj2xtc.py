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
    "desmond_md_job_SaANT_AMP_Spec_trj/clickme.dtr",
    top="amp_spec.pdb"
)

print(f"Loaded {traj.n_frames} frames, {traj.n_atoms} atoms")
traj.save_xtc("SaANT_AMP_Spec_trajectory.xtc")
print("Saved: SaANT_AMP_Spec_trajectory.xtc")

