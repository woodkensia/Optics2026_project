#!/bin/bash

# Define the list of Flare IDs
FLARES=(
"110906925" "120307028" "120307161" "120307294"
"120307426" "120706970" "130514104" "131011272"
"140225048" "140225181" "140901460" "170910662"
"170910794" "170910926"
)

for flare_id in "${FLARES[@]}"; do
    echo "========================================"
    echo "Calculating Diffuse Response for Flare $flare_id..."

    # Navigate into the specific flare directory
    cd "flare_${flare_id}" || { echo "Directory not found! Skipping."; continue; }

    # Automatically locate the Spacecraft (SC) file
    sc_file=$(ls *SC*.fits 2>/dev/null | head -n 1)

    if [ -z "$sc_file" ]; then
        echo "ERROR: Missing SC file. Skipping."
        cd ..
        continue
    fi

    # Execute gtdiffrsp
    # Notice the ../ to point to the main directory for the XML file
    gtdiffrsp evfile="${flare_id}_final.fits" \
              scfile="$sc_file" \
              srcmdl="../source_model.xml" \
              irfs="CALDB"

    # Return to the main directory
    cd ..
    echo "Successfully calculated Diffuse Response for ${flare_id}!"
done

echo "========================================"
echo "Diffuse responses added to all 14 event files."
