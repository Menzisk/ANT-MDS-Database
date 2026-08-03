# ANT-MDS-Database

Molecular dynamics simulation database for 3" aminoglycoside nucleotidyltransferase (ANT) enzymes with their natural substrates, aminoglycoside and flavonoid ligands. Systems were prepared in Maestro (Schrödinger) and simulated with Desmond (Schrödinger).

---

## Systems

| System | Organism                  | Ligands                                                                                               |
| ------ | ------------------------- | ----------------------------------------------------------------------------------------------------- |
| AbANT  | *Acinetobacter baumannii* | Plazomicin, Spectinomycin, Apigenin-7-O-gentiobioside, ATP, ATP-Spectinomycin, AMP-Spectinomycin (covalently linked), Apo, AMP_Spectinoymcin (Non-covalently linked)|
| SaANT  | *Staphylococcus aureus*   | Plazomicin, Spectinomycin, Gallocatechin, ATP, ATP-Spectinomycin, AMP-Spectinomycin(covalently linked), Apo , AMP_Spectinoymcin (Non-covalently linked)|

---

## Repository layout

Each `SYSTEM/LIGAND/` folder follows this structure:

```
configs/          # Desmond .msj and .cfg files
topology/         # .cms and .pdb files (Git LFS)
trajectory/       # .xtc trajectory file (Git LFS)
analysis/
  SID/            # Simulation Interaction Diagram .dat and .eaf files
  SEA/            # Simulation Event Analysis .csv and .st2 files
```

---

## Cloning this repository

This repository uses [Git LFS](https://git-lfs.com/) to store large trajectory and topology files. Install Git LFS **before** cloning, or you'll only pull down small pointer files instead of the actual data:

```bash
git lfs install
git clone https://github.com/Menzisk/ANT-MDS-Database.git
```

If you already cloned without LFS set up, run this inside the repo to fetch the real files:

```bash
git lfs pull
```

---

## Adding a simulation

Drop your files into the right folders:

```bash
cp your_trajectory.xtc AbANT/Plazomicin/trajectory/
cp your_structure.pdb AbANT/Plazomicin/topology/
cp your_config.msj AbANT/Plazomicin/configs/
cp SID_rawdata/*.DAT AbANT/Plazomicin/analysis/SID/
cp SEA_files/* AbANT/Plazomicin/analysis/SEA/
```

Commit and push:

```bash
git add .
git commit -m "Add [SYSTEM] [LIGAND] - [YourName]"
git push origin main
```

---

## Related repository

Analysis scripts and pipeline outputs for this trajectory data are in the companion repository: [ANT-MDS-Analysis](https://github.com/Menzisk/ANT-MDS-Analysis)

---

## Reference

Manuscript in preparation. Sikakane M. et al., 2026.

---

Menzi Sikakane · Medical Scientist (Virology) · MSc (Bioinformatics and Computational Structural Biology), University of the Witwatersrand
