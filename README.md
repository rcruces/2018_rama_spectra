Rama Spectra Analysis
=====================
This repository contains part of the code used in the publication:  

_Khan MS, Rodríguez-Cruces R, Cheng SH, Lau C._ (2020) __Glymphatic clearance of simulated silicon dispersion in mouse brain analyzed by laser induced breakdown spectroscopy__. Heliyon (6) e03702. DOI https://doi.org/10.1016/j.heliyon.2020.e03702


Processing steps:
-------------------
-   [Step 1: Data reading and ordering](#step-1-data-reading-and-ordering)
-   [Step 2: Baseline Correction](#step-2-baseline-correction)
-   [Step 3: Signal to Noise Ratio](#step-3-signal-to-noise-ratio)
-   [Step 4: Smoothing of the signal](#step-4-smoothing-of-the-signal)
-   [Step 5: Normalization of the data and Peak detection](#step-5-normalization-of-the-data-and-peak-detection)
-   [Step 6: Data Visualization](#step-6-data-visualization)
    -   [Heatmap of all cases](#heatmap-of-all-cases)
    -   [Detection of duplicated data and Heatmap of Non-duplicated data](#detection-of-duplicated-data-and-heatmap-of-non-duplicated-data)
-   [Step 7: Spectral Comparison](#step-7-spectral-comparison)

Repository Content:
-------------------
1. `rama_spectra_files/figure-markdown_github`: Directory with the figures.  
1. `Data-Raman_Raul.xlsx`: Dataset  
1. `README.md`: This is a markdown document.   
1. `rama_spectra.Rmd`: This is a R-markdown document that generates the markdown document for github documentation.  
1. **`rama_spectra.r`: THIS IS THE R-CODE.**  

Step 1: Data reading and ordering
=================================

The first steps only uploads the `xlsx` file and concatenates each sheet into one woorkbook.

    ## [1] "READING sheet 1 ..."
    ## [1] "READING sheet 2 ..."
    ## [1] "READING sheet 3 ..."
    ## [1] "READING sheet 4 ..."
    ## [1] "READING sheet 5 ..."
    ## [1] "READING sheet 6 ..."
    ## [1] "READING sheet 7 ..."
    ## [1] "READING sheet 8 ..."
    ## [1] "READING sheet 9 ..."
    ## [1] "READING sheet 10 ..."

Step 2: Baseline Correction
===========================

Baseline is corrected with a 2nd derivative constrained weighted regression. It was the optimal method provided from the package `baseline` from R.
The next two graphs show the raw data of Control.1-area.1 on the left with the baseline fitted (red line) and the baseline fitted on the right.

![](rama_spectra_files/figure-markdown_github/unnamed-chunk-3-1.png)

Step 3: Signal to Noise Ratio
=============================

The SNR was caculated here in case is needed for further analysis, as a cofounding variable, as a set up for smothing or just as quality control check point. Blue are control cases, red experimental.
![](rama_spectra_files/figure-markdown_github/unnamed-chunk-4-1.png)

Step 4: Smoothing of the signal
===============================

Two options here the Nadayara-Watson Kernel or a fast furier transformation with convolution.
The smoothing of the signal is made in order to improve the SNR.

![](rama_spectra_files/figure-markdown_github/unnamed-chunk-5-1.png)

Step 5: Normalization of the data and Peak detection
==================================================

This is done in two steps first we normalized all data to the Mean Absolute Deviation (MAD) and then we search those peaks that are above 2 standart deviation of the MAD. ![](rama_spectra_files/figure-markdown_github/unnamed-chunk-6-1.png)

Step 6: Data Visualization
==========================

### Heatmap of all cases

![](rama_spectra_files/figure-markdown_github/unnamed-chunk-7-1.png)

### Detection of duplicated data and Heatmap of Non-duplicated data

![](rama_spectra_files/figure-markdown_github/unnamed-chunk-8-1.png)

#### Control vs Experiment spectra

![](rama_spectra_files/figure-markdown_github/unnamed-chunk-9-1.png)

