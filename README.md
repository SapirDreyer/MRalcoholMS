# MSalcoholMR

## Mendelian randomisation
To determine whether alcohol consumption may causally impact MS risk, we performed two-sample Mendelian Randomisation (MR). Three GWASs addressing alcohol consumption (as exposure) were obtained, and associated single nucleotide polymorphisms (SNPs) were extracted. To ensure that the instruments of the exposure are independent, we performed clumping using the IEU GWAS database using clamping window of 10000kb, and r2 cutoff of 0.001. SNPs associated with alcohol consumption were extracted from the IMSGC GWAS [5] as outcome, and the exposure-outcome datasets were harmonised using the TwoSampleMR package in R. SNPs that were missing from the outcome dataset were excluded from the analysis, and palindromic SNPs with minor allele frequency above 0.42 were discarded. Sensitivity analyses included tests for heterogeneity and horizontal pleiotropy. To account for heterogeneity and pleiotropy, MR was performed using three methods: Inverse-variance weighted (IVW) random effects, weighted median and MR-PRESSO.


### Alcohol Consumption
SNPs associated with alcohol consumption were extracted from a meta-analysis performed by the GWAS & Sequencing Consortium of Alcohol and Nicotine use (GSCAN) [1]. The meta-analysis included 537,349 participants of European origin, and alcohol consumption was recorded as number of drinks consumed per week (Mean±SD 10.8±1.90). This GWAS reported  99 variants within 81 loci associated with alcohol consumption at genome-wide significance, with an overall SNP heritability of 4.2%.

In our MR analysis, 31 SNPs were used. IVW random effects disclosed an OR of 1.28, 95% CI = 0.82-2, p value = 0.27, suggesting no causal relationship between drinks consumed per week and risk of MS. There was no substantial evidence that heterogeneity or horizontal pleiotropy were biasing the IVW result (Cochran's Q = 42.37, p = 0.07, MR-Egger intercept = -0.003, p = 0.72). Furthermore, weighted median analysis and MR-PRESSO did not yield significant results.

### Alcohol Use Disorders Identification Test (AUDIT)
We further assessed SNPs collected from a GWAS of 121,604 participants of European ancestry from UKB, recording participants’ AUDIT scores [2]. AUDIT is a screening tool designed to identify hazardous alcohol use and consists of ten items across three dimensions – alcohol consumption, dependence symptoms and problematic alcohol use. The GWAS included 8 loci with 12 variants. SNP heritability of all AUDIT phenotypes ranged from 9% to 12%, calculated using a genomic restricted maximum likelihood (GREML) method implemented in Genetic Complex Trait Analysis (GCTA).
In our MR analysis, 8 SNPs were used. IVW random effects disclosed an OR of 0.66, 95% CI = 0.05-7.88, p value = 0.74, suggesting no causal relationship between AUDIT score and risk of MS. There was evidence of heterogeneity (Cochran's Q = 17.30, p = 0.02), but no horizontal pleiotropy was found (MR-Egger intercept = -0.027, p = 0.64). Weighted median and MR-PRESSO were performed, yielding no significant relationship.


### Drinkers Vs. Non-Drinkers
Finally, we performed an MR analysis using the dichotomised data described in the replication study section, which was extracted from UKB. 
In the analysis, 23 SNPs were used. IVW random effects disclosed an OR of 0.02, 95% CI = 0-1.6, p value = 0.08, suggesting no causal relationship between never drinking and risk of MS. There was no substantial evidence of heterogeneity or horizontal pleiotropy (Cochran's Q = 32.79, p = 0.06, MR-Egger intercept = -0.013, p = 0.36), and weighted median and MR-PRESSO did not yield significant results.

### References

1.	Liu M, Jiang Y, Wedow R, Li Y, Brazel DM, Chen F, Datta G, Davila-Velderrain J, McGuire D, Tian C, Zhan X. Association studies of up to 1.2 million individuals yield new insights into the genetic etiology of tobacco and alcohol use. Nature genetics. 2019 Feb;51(2):237-44.
2.	Sanchez-Roige S, Palmer AA, Fontanillas P, Elson SL, 23andMe Research Team, the Substance Use Disorder Working Group of the Psychiatric Genomics Consortium, Adams MJ, Howard DM, Edenberg HJ, Davies G, Crist RC, Deary IJ. Genome-wide association study meta-analysis of the Alcohol Use Disorders Identification Test (AUDIT) in two population-based cohorts. American Journal of Psychiatry. 2019 Feb 1;176(2):107-18.





## Mendelian Randomization to assess causality between alcohol consumption and multiple sclerosis

|                                         |             |           |           | IVW-random effects method |           |      | Weighted median method |           |      | MR-PRESSO |           |      |              |       |             |
|-----------------------------------------|-------------|-----------|-----------|---------------------------|-----------|------|------------------------|-----------|------|-----------|-----------|------|--------------|-------|-------------|
| Exposure Data                           | Sample Size | Used SNPs | PubMed ID | OR                        | 95% CI    | p    | OR                     | 95% CI    | p    | OR        | 95% CI    | p    | Cochrane's Q | P het | P intercept |
| Drinks Per Week - GSCAN (Including UKB) | 537,349     | 31        | 30643251  | 1.28                      | 0.82-2    | 0.27 | 0.90                   | 0.51-1.6  | 0.72 | 1.06      | 0.99-1.13 | 0.79 | 42.37        | 0.07  | 0.72        |
| AUDIT Score - UKB                       | 121,604     | 8         | 30336701  | 0.66                      | 0.05-7.88 | 0.74 | 0.57                   | 0.06-5.36 | 0.63 | 0.30      | 0.16-0.53 | 0.21 | 17.30        | 0.02  | 0.64        |
| Never Drink - UKB                       | 574,966     | 23        |           | 0.02                      | 0-1.6     | 0.08 | 0.14                   | 0-20.77   | 0.44 | 0.15      | 0.08-0.27 | 0.24 | 32.79        | 0.06  | 0.36        |

Drinks Per Week MR methods:


![](Plots/Drinks%20Per%20Week.png)

UKB AUDIT MR methods:


![](Plots/UKB%20AUDIT.png)


UKB Never Drink MR methods:


![](Plots/UKB%20Never%20Drink.png)
