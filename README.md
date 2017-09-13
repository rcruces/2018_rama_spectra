-   [Step 1: Data reading & ordering](#step-1-data-reading-ordering)
    -   [Baseline Correction](#baseline-correction)
-   [Signal to Noise Ratio](#signal-to-noise-ratio)
-   [Smoothing of the signal](#smoothing-of-the-signal)
-   [Normalization of the data & Peak detection](#normalization-of-the-data-peak-detection)
-   [Heatmap of all cases](#heatmap-of-all-cases)
-   [Detection of duplicated data & Heatmap of Non-duplicated data](#detection-of-duplicated-data-heatmap-of-non-duplicated-data)
-   [Control vs Experiment spectra](#control-vs-experiment-spectra)
-   [Spectral comparison Comparison](#spectral-comparison-comparison)

Step 1: Data reading & ordering
===============================

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

Baseline Correction
-------------------

Baseline is corrected with a 2nd derivative constrained weighted regression. It was the optimal method provided from the package `baseline` from R.
The next two graphs show the raw data of Control.1-area.1 on the left with the baseline fitted (red line) and the baseline fitted on the right.

![](rama_spectra_files/figure-markdown_github/unnamed-chunk-3-1.png)

Signal to Noise Ratio
=====================

The SNR was caculated here in case is needed for further analysis, as a cofounding variable, as a set up for smothing or just as quality control check point. Blue are control cases, red experimental.
![](rama_spectra_files/figure-markdown_github/unnamed-chunk-4-1.png)

Smoothing of the signal
=======================

Two options here the Nadayara-Watson Kernel or a fast furier transformation with convolution.
The smoothing of the signal is made in order to improve the SNR.
**Note:** I still need to interpole the smoothing to the wavelenght!!! ![](rama_spectra_files/figure-markdown_github/unnamed-chunk-5-1.png)

Normalization of the data & Peak detection
==========================================

This is done in two steps first we normalized all data to the Mean Absolute Deviation (MAD) and then we search those peaks that are above 2 standart deviation of the MAD. ![](rama_spectra_files/figure-markdown_github/unnamed-chunk-6-1.png)

Heatmap of all cases
====================

![](rama_spectra_files/figure-markdown_github/unnamed-chunk-7-1.png)

Detection of duplicated data & Heatmap of Non-duplicated data
=============================================================

![](rama_spectra_files/figure-markdown_github/unnamed-chunk-8-1.png)

Control vs Experiment spectra
=============================

![](rama_spectra_files/figure-markdown_github/unnamed-chunk-9-1.png)

Spectral Comparison
==============================
