#!/bin/bash

FLARES=("120307028" "170910662")

for flare_id in "${FLARES[@]}"; do
    echo "========================================"
    echo "Debugging gtmktime for Flare $flare_id..."

    cd "flare_${flare_id}" || continue

    sc_file=$(ls *SC*.fits 2>/dev/null | head -n 1)

    # Running with a relaxed filter to catch slewing data
    gtmktime scfile="$sc_file" \
             filter="DATA_QUAL>0" \
             roicut="no" \
             evfile="${flare_id}_filtered.fits" \
             outfile="${flare_id}_final.fits"

    cd ..
    echo "Attempted to generate ${flare_id}_final.fits!"
done
