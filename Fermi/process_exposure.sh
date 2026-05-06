#!/bin/bash

FLARES=(
"110906925" "120307028" "120307161" "120307294"
"120307426" "120706970" "130514104" "131011272"
"140225048" "140225181" "140901460" "170910662"
"170910794" "170910926"
)

for flare_id in "${FLARES[@]}"; do
    echo "========================================"
    echo "Calculating Livetime and Exposure for Flare $flare_id..."

    cd "flare_${flare_id}" || continue

    # Find the SC file dynamically
    sc_file=$(ls *SC*.fits 2>/dev/null | head -n 1)

    if [ -z "$sc_file" ]; then
        echo "ERROR: Missing SC file. Skipping."
        cd ..
        continue
    fi

    # 1. Run gtltcube (Livetime Cube)
    echo "Running gtltcube..."
    gtltcube evfile="${flare_id}_final.fits" \
             scfile="$sc_file" \
             outfile="${flare_id}_ltcube.fits" \
             dcostheta=0.025 \
             binsz=1 \
             zmax=100

    # 2. Run gtexpmap (Exposure Map)
    echo "Running gtexpmap..."
    # Note: srcrad is typically your ROI (20) + 10 = 30
    gtexpmap evfile="${flare_id}_final.fits" \
             scfile="$sc_file" \
             expcube="${flare_id}_ltcube.fits" \
             outfile="${flare_id}_expmap.fits" \
             irfs="CALDB" \
             srcrad=30 \
             nlong=120 \
             nlat=120 \
             nenergies=20

    cd ..
    echo "Finished Exposure Map for ${flare_id}!"
done

echo "========================================"
echo "All Livetime Cubes and Exposure Maps complete."

