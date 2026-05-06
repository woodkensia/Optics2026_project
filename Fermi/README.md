# Fermi-LAT Solar Flare Spatial Analysis
**Author:** Woodkensia Charles  
**Institution:** University of New Mexico, Department of Physics and Astronomy  

## Project Overview
This repository contains the automated bash scripts, XML models, and terminal pipeline used to process Fermi-LAT high-energy gamma-ray data for a sample of solar flares. The primary objective is to perform spatial and maximum likelihood analysis to determine the flux and test statistic (TS) of the flares.

### Data Sample & SAA Exclusions
The initial sample contained 14 solar flares. However, **Flares 120307028 and 170910662 were excluded from the final spatial analysis.** A diagnostic test of the spacecraft files revealed that their impulsive time windows completely coincided with periods of zero data quality (`DATA_QUAL=0`), physically corresponding to LAT detector blackouts during South Atlantic Anomaly (SAA) passages or autonomous repoint slews. The final analysis was performed on the remaining 12 high-quality flares.

---

## Automated Data Processing Pipeline

The data was processed using the standard Fermi ScienceTools via a series of automated bash loops.

### 1. Data Selection (`process_flares.sh`)
Filtered the raw photon data around the specific flare coordinates.
* **Tool:** `gtselect`
* **Parameters:** `rad=20`, `emin=100`, `emax=100000`, `zmax=100`

### 2. Time Filtering (`process_mktime.sh`)
Applied the standard science configuration filter to remove Earth albedo and slewing data.
* **Tool:** `gtmktime`
* **Parameters:** `filter="DATA_QUAL>0 && LAT_CONFIG==1"`, `roicut="yes"`

### 3. Exposure Calculations (`process_exposure.sh`)
Calculated the livetime cube and exposure maps required for unbinned likelihood analysis.
* **Tool 1:** `gtltcube` (Parameters: `dcostheta=0.025`, `binsz=1`, `zmax=100`)
* **Tool 2:** `gtexpmap` (Parameters: `irfs="CALDB"`, `srcrad=30`, `nlong=120`, `nlat=120`, `nenergies=20`)

### 4. Background Modeling (`process_diffrsp.sh`)
Calculated the diffuse response using the galactic and isotropic background models defined in the master `source_model.xml` file.
* **Tool:** `gtdiffrsp`
* **Models Used:** `gll_iem_v07` and `iso_P8R3_SOURCE_V3_v1`

### 5. High-Resolution TS Mapping (`process_tsmap.sh`)
Generated precise probability heatmaps to confirm the spatial origin of the gamma-ray emission.
* **Tool:** `gttsmap`
* **Parameters:** `statistic="UNBINNED"`, `optimizer="MINUIT"`, `irfs="P8R3_SOURCE_V3"`, `nxpix=30`, `nypix=30`, `binsz=0.1`, `proj="STG"`

### 6. Maximum Likelihood Extraction (`process_gtlike.sh`)
Performed the final unbinned maximum likelihood analysis to extract the spectral parameters, flux, and overall Test Statistic (TS) for each flare. Results were automatically redirected and saved to individual `_results.txt` files for cataloging.
* **Tool:** `gtlike`
* **Parameters:** `statistic="UNBINNED"`, `optimizer="MINUIT"`, `irfs="P8R3_SOURCE_V3"`