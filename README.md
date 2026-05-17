# ANT-MD-Database

Molecular dynamics simulation database for 3" aminoglycoside nucleotidyltransferase (ANT) enzymes with their natural substrates, aminoglycoside, flavonoid ligands. Systems were prepared in Maestro (Schrödinger) and simulated with Desmond (Schrödinger).

---

## Systems

| System | Organism | Ligands |
|--------|----------|---------|
| AbANT | *Acinetobacter baumannii* | Plazomicin, Spectinomycin, Apigenin-7-O-gentiobioside, ATP, ATP-Spectinomycin, AMP-Spectinomycin, Apo |
| SaANT | *Staphylococcus aureus* | Plazomicin, Spectinomycin, Gallocatechin, ATP, ATP-Spectinomycin, AMP-Spectinomycin, Apo |

---

## Repository layout

Each `SYSTEM/LIGAND/` folder follows this structure:

```
configs/          # Desmond .msj and .cfg files
topology/         # .cms and .pdb files (Git LFS)
trajectory/       # .xtc trajectory file (Git LFS)
analysis/
  SID/            # Simulation Interaction Diagram .DAT files
  SEA/            # Simulation Event Analysis .csv and .st2 files
```

---

## Adding a simulation

Clone the repo:

```bash
git clone https://github.com/Menzisk/ANT-MD-Database.git
```

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

Menzi Sikakane · Medical Scientist (Virology) · MSc Molecular and Cell Biology (Computational Structural Biology), University of the Witwatersrand
