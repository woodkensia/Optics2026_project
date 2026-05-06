#!/bin/bash

# Define the array: FlareID RA Dec
FLARES=(
"110906925 165.08 6.369"
"120307028 347.738 -5.261"
"120307161 347.861 -5.209"
"120307294 347.984 -5.158"
"120307426 348.107 -5.106"
"120706970 106.372 22.585"
"130514104 50.898 18.594"
"131011272 196.537 -7.034"
"140225048 337.915 -9.257"
"140225181 338.041 -9.208"
"140901460 160.353 8.293"
"170910662 168.854 4.79"
"170910794 168.973 4.74"
"170910926 169.092 4.69"
)

for line in "${FLARES[@]}"; do
    read -r flare_id ra dec <<< "$line"
    echo "========================================"
    echo "Calculating High-Res TS Map for Flare $flare_id..."

    cd "flare_${flare_id}" || continue

    # Locate Spacecraft file
    sc_file=$(ls *SC*.fits 2>/dev/null | head -n 1)

    if [ -z "$sc_file" ]; then
        echo "ERROR: Missing SC file for ${flare_id}. Skipping."
        cd ..
        continue
    fi

    # Run gttsmap using the strict high-resolution and unbinned parameters
    gttsmap statistic="UNBINNED" \
            scfile="$sc_file" \
            evfile="${flare_id}_final.fits" \
            expmap="${flare_id}_expmap.fits" \
            expcube="none" \
            srcmdl="../source_model.xml" \
            irfs="P8R3_SOURCE_V3" \
            optimizer="MINUIT" \
            outfile="${flare_id}_tsmap.fits" \
            nxpix=30 \
            nypix=30 \
            binsz=0.1 \
            coordsys="CEL" \
            xref="$ra" \
            yref="$dec" \
            proj="STG"

    cd ..
    echo "TS Map successfully generated for ${flare_id}!"
done

echo "========================================"
echo "All High-Res TS Maps are complete."

