#!/bin/bash

# Define the list of Flare IDs
FLARES=(
"110906925" "120307028" "120307161" "120307294"
"120307426" "120706970" "130514104" "131011272"
"140225048" "140225181" "140901460" "170910662"
"170910794" "170910926"
)

# Loop through each flare
for flare_id in "${FLARES[@]}"; do
    echo "========================================"
    echo "Running gtmktime for Flare $flare_id..."

    # Navigate into the specific flare directory
    cd "flare_${flare_id}" || { echo "Directory not found! Skipping."; continue; }

    # Automatically locate the Spacecraft (SC) file
    sc_file=$(ls *SC*.fits 2>/dev/null | head -n 1)

    if [ -z "$sc_file" ]; then
        echo "ERROR: No SC file found in flare_${flare_id}. Skipping to next flare."
        cd ..
        continue
    fi

    # Execute gtmktime non-interactively
    gtmktime scfile="$sc_file" \
             filter="DATA_QUAL>0 && LAT_CONFIG==1" \
             roicut="yes" \
             evfile="${flare_id}_filtered.fits" \
             outfile="${flare_id}_final.fits"

    # Return to the main directory for the next loop
    cd ..
    echo "Successfully generated ${flare_id}_final.fits!"
done

echo "========================================"
echo "Good Time Intervals calculated for all 14 flares."

