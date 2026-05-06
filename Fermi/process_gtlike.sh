#!/bin/bash

# The Final 12 Surviving Flares
FLARES=(
"110906925" "120307161" "120307294" "120307426"
"120706970" "130514104" "131011272" "140225048"
"140225181" "140901460" "170910794" "170910926"
)

for flare_id in "${FLARES[@]}"; do
    echo "========================================"
    echo "Running Maximum Likelihood for Flare $flare_id..."

    cd "flare_${flare_id}" || continue

    # Locate the Spacecraft file
    sc_file=$(ls *SC*.fits 2>/dev/null | head -n 1)

    if [ -z "$sc_file" ]; then
        echo "ERROR: Missing SC file for ${flare_id}. Skipping."
        cd ..
        continue
    fi

    # Run gtlike and redirect the math output into a clean text file
    gtlike statistic="UNBINNED" \
           scfile="$sc_file" \
           evfile="${flare_id}_final.fits" \
           expmap="${flare_id}_expmap.fits" \
           expcube="${flare_id}_ltcube.fits" \
           srcmdl="../source_model.xml" \
           irfs="P8R3_SOURCE_V3" \
           optimizer="MINUIT" > "${flare_id}_results.txt"

    cd ..
    echo "Likelihood analysis saved to ${flare_id}_results.txt!"
done

echo "========================================"
echo "All 12 flares completely analyzed. You are done with the terminal!"
