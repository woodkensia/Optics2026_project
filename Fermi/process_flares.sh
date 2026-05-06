#!/bin/bash

# Define the data array: FlareID RA Dec
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

# Loop through each flare in the array
for line in "${FLARES[@]}"; do
    # Extract the ID, RA, and Dec from the current line
    read -r flare_id ra dec <<< "$line"
    echo "========================================"
    echo "Processing Flare $flare_id..."

    # Navigate into the specific flare directory
    cd "flare_${flare_id}" || { echo "Directory flare_${flare_id} not found! Skipping."; continue; }

    # Automatically locate the Photon (PH) file
    ph_file=$(ls *PH*.fits 2>/dev/null | head -n 1)

    if [ -z "$ph_file" ]; then
        echo "ERROR: No PH file found in flare_${flare_id}. Skipping to next flare."
        cd ..
        continue
    fi

    echo "Found raw data: $ph_file"
    echo "Running gtselect with RA=$ra, Dec=$dec..."

    # Execute gtselect non-interactively with your specific parameters
    gtselect infile="$ph_file" \
             outfile="${flare_id}_filtered.fits" \
             ra="$ra" \
             dec="$dec" \
             rad=20 \
             emin=100 \
             emax=100000 \
             zmax=100 \
             tmin=0 \
             tmax=0

    # Return to the main directory for the next loop
    cd ..
    echo "Successfully generated ${flare_id}_filtered.fits!"
done

echo "========================================"
echo "All 14 flares have been processed."
