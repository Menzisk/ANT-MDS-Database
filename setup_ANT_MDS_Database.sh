#!/bin/bash
#  ANT-MDS-Database — Full Setup & File Copy Script
#  Author : Menzi Sikakane
#  GitHub : https://github.com/Menzisk/ANT-MDS-Database
#  Purpose: Create the database folder structure and copy all
#           Desmond simulation outputs from Windows (via WSL)
#           into the organised GitHub database.
#  Usage  : bash setup_ANT_MDS_Database.sh

set -e  # Exit immediately if any command fails

# ── CONFIGURATION ─────────────────────────────────────────────
WIN="/mnt/c/Users/sindy/Downloads/ANT-MD Simulations"
DB=~/ANT-MDS-Database
# ──────────────────────────────────────────────────────────────

echo ""
echo "  ANT-MDS-Database Setup Script"
echo ""

# ── PHASE 1: CHECK DEPENDENCIES ───────────────────────────────
echo "[1/5] Checking dependencies"

if ! command -v git &> /dev/null; then
    echo "Git not found. Installing"
    sudo apt update && sudo apt install git -y
else
    echo "  ✓ Git: $(git --version)"
fi

if ! command -v git-lfs &> /dev/null; then
    echo "Git LFS not found. Installing"
    sudo apt install git-lfs -y
else
    echo "  ✓ Git LFS: $(git lfs version)"
fi

if ! command -v tree &> /dev/null; then
    echo "tree not found. Installing"
    sudo apt install tree -y
fi

echo ""

# ── PHASE 2: CREATE FOLDER STRUCTURE ──────────────────────────
echo "[2/5] Creating folder structure"

mkdir -p "$DB"
cd "$DB"

# AbANT — 8 systems
for system in \
    Plazomicin \
    Spectinomycin \
    "Apigenin-7-O-gentiobioside" \
    ATP \
    ATP-Spectinomycin \
    AMP-Spectinomycin \
    AMP_Spectinomycin \
    Apo; do
    mkdir -p "AbANT/$system"/{configs,topology,trajectory,analysis/{SID,SEA,csvs,figures,scripts}}
done

# SaANT — 8 systems
for system in \
    Plazomicin \
    Spectinomycin \
    Gallocatechin \
    ATP \
    ATP-Spectinomycin \
    AMP-Spectinomycin \
    AMP_Spectinomycin \
    Apo; do
    mkdir -p "SaANT/$system"/{configs,topology,trajectory,analysis/{SID,SEA,csvs,figures,scripts}}
done

# Shared scripts folder
mkdir -p scripts/utils

echo "  ✓ AbANT systems: $(ls AbANT/ | wc -l)/8 folders created"
echo "  ✓ SaANT systems: $(ls SaANT/ | wc -l)/8 folders created"
echo ""

# ── PHASE 3: GIT + LFS INIT ───────────────────────────────────
echo "[3/5] Initialising Git and LFS"

git init
git lfs install

git lfs track "*.xtc"
git lfs track "*.pdb"
git lfs track "*.cms"

git add .gitattributes

echo "  ✓ Git initialised"
echo "  ✓ LFS tracking: *.xtc, *.pdb, *.cms"
echo ""

# ── PHASE 4: CREATE CONFIG FILES ──────────────────────────────
echo "[4/5] Creating .gitignore and README"

cat > .gitignore << 'EOF'
# Desmond raw trajectory folders (too large)
*_trj/

# Large Desmond output files - store locally only
*.ene
*.cpt
*.log
*_out.tgz
*-out.tgz
*multisim_checkpoint
*checkpoint_*

# Python cache
__pycache__/
*.pyc
.ipynb_checkpoints/

# macOS
.DS_Store

# Windows
Thumbs.db
EOF

cat > README.md << 'EOF'
# ANT-MDS-Database

Molecular dynamics simulation database for 3" aminoglycoside
nucleotidyltransferase (ANT) enzymes with their natural substrates,
aminoglycoside, flavonoid, and nucleotide ligands. Systems were
prepared in Maestro (Schrödinger) and simulated with Desmond
(Schrödinger).

---

## Systems

| System | Organism                  | Ligands |
|--------|---------------------------|---------|
| AbANT  | *Acinetobacter baumannii* | Plazomicin, Spectinomycin, Apigenin-7-O-gentiobioside, ATP, ATP-Spectinomycin, AMP-Spectinomycin, AMP_Spectinomycin, Apo |
| SaANT  | *Staphylococcus aureus*   | Plazomicin, Spectinomycin, Gallocatechin, ATP, ATP-Spectinomycin, AMP-Spectinomycin, AMP_Spectinomycin, Apo |

---

## Folder structure

Each system/ligand folder contains:

```
SystemName/
├── configs/            ← Desmond .msj and .cfg simulation parameters
├── topology/           ← .cms and .pdb structure files (Git LFS)
├── trajectory/         ← converted .xtc trajectory file (Git LFS)
└── analysis/
    ├── SID/            ← Simulation Interaction Diagram (.DAT and .eaf files)
    ├── SEA/            ← Simulation Event Analysis (.csv, .st2)
```

---

## Setup

To recreate this database structure locally, run:

```bash
bash scripts/setup_ANT_MDS_Database.sh
```

> Note: Requires WSL or Linux with Git and Git LFS installed.
> The Windows source paths at the top of the script are set for
> the original data location and will need to be updated for
> your own machine.

---

## How to contribute your simulation

1. Clone this repo
```bash
git clone https://github.com/Menzisk/ANT-MDS-Database.git
```

2. Copy your files into the correct folder
```bash
cp your_trajectory.xtc  AbANT/Plazomicin/trajectory/
cp your_structure.pdb   AbANT/Plazomicin/topology/
cp your_config.msj      AbANT/Plazomicin/configs/
cp SID_rawdata/*.DAT    AbANT/Plazomicin/analysis/SID/
cp SEA_files/*          AbANT/Plazomicin/analysis/SEA/
```

3. Stage, commit and push
```bash
git add .
git commit -m "Add [SYSTEM] [LIGAND] simulation - [YourName]"
git push origin main
```

---

## Software

- Desmond (Schrödinger) — MD simulation
- Maestro (Schrödinger) — system preparation 
- MDAnalysis — trajectory analysis
- Python 3.8+ — dPCA, FEL, distance analysis pipelines

---

## Contact

Menzi Sikakane — Registered Medical Scientist (Virology), HPCSA
MSc Molecular and Cell Biology (Bioinformatics and Computational Structural Biology), Wits
EOF

# Add .gitkeep to preserve empty folders
find . -type d -empty -not -path "./.git/*" -exec touch {}/.gitkeep \;

echo "  ✓ .gitignore created"
echo "  ✓ README.md created"
echo "  ✓ Empty folder placeholders added"
echo ""

# ── PHASE 5: COPY SIMULATION FILES ────────────────────────────
echo "[5/5] Copying simulation files from Windows"
echo "      Source: $WIN"
echo ""

# Helper function — warns instead of crashing if a path is missing
safe_copy() {
    local src="$1"
    local dest="$2"
    if [ -d "$src" ]; then
        cp -r "$src/." "$dest/"
        echo "      ✓ Copied: $(basename $src)"
    elif [ -f "$src" ]; then
        cp "$src" "$dest/"
        echo "      ✓ Copied: $(basename $src)"
    else
        echo "      ⚠ WARNING: Not found — $src"
        echo "        Copy manually to: $dest"
    fi
}

# ── AbANT ──────────────────────────────────────────────────────

echo "  → AbANT: Plazomicin"
SRC="$WIN/desmond_setup_20_AbANT_Plazomicin_2"
DEST="$DB/AbANT/Plazomicin"
safe_copy "$SRC/desmond_md_job_AbPlazomicin"                        "$DEST/configs"
safe_copy "$SRC/Simulation Interaction Diagram/data1/raw-data"      "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → AbANT: Spectinomycin"
SRC="$WIN/desmond_setup_20_AbANT_Spectinomycin"
DEST="$DB/AbANT/Spectinomycin"
safe_copy "$SRC/desmond_md_job_AbANT_Spectinomycin"                 "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → AbANT: Apigenin-7-O-gentiobioside"
SRC="$WIN/desmond_setup_20_AbANT_Apigenin"
DEST="$DB/AbANT/Apigenin-7-O-gentiobioside"
safe_copy "$SRC/desmond_md_job_AbANT_Apigenin"                      "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram"                    "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → AbANT: ATP"
SRC="$WIN/desmond_setup_20_AbANT_ATP"
DEST="$DB/AbANT/ATP"
safe_copy "$SRC/desmond_md_job_AbANT_ATP"                           "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → AbANT: ATP-Spectinomycin"
SRC="$WIN/desmond_setup_20_AbANT_ATP_Spectinomycin"
DEST="$DB/AbANT/ATP-Spectinomycin"
safe_copy "$SRC/desmond_md_job_AbANT_ATP_Spectinomycin"             "$DEST/configs"
safe_copy "$SRC/Simulation Interaction Diagram Spec/data1/raw-data" "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → AbANT: AMP-Spectinomycin"
SRC="$WIN/desmond_setup_20_AbANT_AMP_Spectinomycin"
DEST="$DB/AbANT/AMP-Spectinomycin"
safe_copy "$SRC/desmond_md_job_Ab_AMP_Spectinomycin"                "$DEST/configs"
safe_copy "$SRC/Simulation Interaction Diagram/data1/raw-data"      "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → AbANT: AMP_Spectinomycin"
SRC="$WIN/desmond_md_Ab_AMP--Strept-20250916T111514Z-1-001"
DEST="$DB/AbANT/AMP_Spectinomycin"
safe_copy "$SRC/desmond_md_Ab_AMP--Strept"                          "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → AbANT: Apo"
SRC="$WIN/desmond_setup_20_AbANT_Apo"
DEST="$DB/AbANT/Apo"
safe_copy "$SRC/desmond_md_job_AbANTApo"                            "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

# ── SaANT ──────────────────────────────────────────────────────

echo "  → SaANT: Plazomicin"
SRC="$WIN/desmond_setup_20_SaANT_Plazomicin"
DEST="$DB/SaANT/Plazomicin"
safe_copy "$SRC/desmond_md_job_SaANT_Plazomicin"                    "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → SaANT: Spectinomycin"
SRC="$WIN/desmond_setup_20_SaANT_Spectinomycin"
DEST="$DB/SaANT/Spectinomycin"
safe_copy "$SRC/desmond_md_job_SaANT_Spectinomycin"                 "$DEST/configs"
safe_copy "$SRC/Simulation interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → SaANT: Gallocatechin"
SRC="$WIN/desmond_setup_20_SaANT_Gallocatechin"
DEST="$DB/SaANT/Gallocatechin"
safe_copy "$SRC/desmond_md_job_SaANT_Gallocatechin"                 "$DEST/configs"
safe_copy "$SRC/Simulation Interaction Diagram/data1/raw-data"      "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → SaANT: ATP"
SRC="$WIN/desmond_setup_20_SaANT_ATP"
DEST="$DB/SaANT/ATP"
safe_copy "$SRC/desmond_md_job_SaANT_ATP"                           "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → SaANT: ATP-Spectinomycin"
SRC="$WIN/desmond_setup_20_Sa_ATP--Spect"
DEST="$DB/SaANT/ATP-Spectinomycin"
safe_copy "$SRC/desmond_md_job_SaANT_ATP_Spectinomycin"             "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → SaANT: AMP-Spectinomycin"
SRC="$WIN/desmond_setup_20_SaANT_AMP_Spectinomycin"
DEST="$DB/SaANT/AMP-Spectinomycin"
safe_copy "$SRC/desmond_md_job_Sa_AMP_Spectinomycin"                "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → SaANT: AMP_Spectinomycin"
SRC="$WIN/desmond_setup_20_Sa_AMP--Spect_2"
DEST="$DB/SaANT/AMP_Spectinomycin"
safe_copy "$SRC/desmond_md_job_SaANT_AMP_Spec"                      "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

echo "  → SaANT: Apo"
SRC="$WIN/desmond_setup_20_SaANT_Apo"
DEST="$DB/SaANT/Apo"
safe_copy "$SRC/desmond_md_job_SaANT_Apo"                           "$DEST/configs"
safe_copy "$SRC/Simulation Interactions Diagram/data1/raw-data"     "$DEST/analysis/SID"
safe_copy "$SRC/Simulation Event Analysis"                          "$DEST/analysis/SEA"

# ── SUMMARY ───────────────────────────────────────────────────
echo ""
echo "  SUMMARY"
echo "  AbANT systems : $(ls $DB/AbANT/ | wc -l)/8"
echo "  SaANT systems : $(ls $DB/SaANT/ | wc -l)/8"
echo ""
echo "  Check for any ⚠ WARNING lines above and fix those paths."
echo ""
echo "  Next steps:"
echo "  1. Connect to GitHub:"
echo "     git remote add origin https://github.com/Menzisk/ANT-MDS-Database.git"
echo "  2. Stage and push:"
echo "     git add ."
echo "     git commit -m 'Initial commit: full ANT-MDS simulation database'"
echo "     git branch -M main"
echo "     git push -u origin main"
echo ""
echo "  Database location: $DB"