library(TwoSampleMR)
library(readr)
library(dplyr)
library(MRPRESSO)
library(tidyr)

set.seed(1)
#UKB Never drinkers
## importing exposure data (GWAS of Exposure) - fitting col names to standard of package - Since File is large, a filtered version of significant SNPs appearing in MS GWAS was created.
never_drink_GWAS <- read_csv("alcohol_gwas_filtered.csv")
never_drink_GWAS = dplyr::rename(never_drink_GWAS,'samplesize'=n_complete_samples,'eaf'=minor_AF)
never_drink_GWAS = dplyr::rename(never_drink_GWAS,'SNP'=snp)

head (never_drink_GWAS)

# MS GWAS - missing beta and SE -calculation of z score and log(OR) to recover them - a filtered file which includes only SNPs from the UKB never drink GWAS was used
ms_never_drink_GWAS <- read_csv("ms_gwas_filtered.csv")
ms_never_drink_GWAS = dplyr::mutate(ms_never_drink_GWAS,'z_score' = qnorm(1-(P/2)))
ms_never_drink_GWAS = dplyr::mutate(ms_never_drink_GWAS,'logodds' = log(OR))
ms_never_drink_GWAS = dplyr::mutate(ms_never_drink_GWAS, 'se' = sqrt((logodds/z_score)^2))
ms_never_drink_GWAS = dplyr::rename(ms_never_drink_GWAS,'effect_allele' = A1, 'other_allele' = A2, 'beta' = logodds,'pval'=P)
head (ms_never_drink_GWAS)

#### Format data exposure and outcome
never_drink_exp = format_data(never_drink_GWAS,type='exposure')
ms_never_drink_out = format_data(ms_never_drink_GWAS,type='outcome')

# clumping- making sure snps are independent of one another based on the IEU GWAS database 
never_drink_exp <- clump_data(never_drink_exp)


# harmonise - This creates a new data frame that has the exposure data and outcome data combined.
never_drink_dat <- harmonise_data(
  exposure_dat = never_drink_exp, 
  outcome_dat = ms_never_drink_out
)

# Perform MR
res_never_drink <- mr(never_drink_dat)#, method_list = c('mr_ivw'))
OR_res_never_drink <- generate_odds_ratios(res_never_drink)

res_presso_never_drink <- mr_presso(BetaOutcome = "beta.outcome", BetaExposure = "beta.exposure", SdOutcome = "se.outcome", SdExposure = "se.exposure", OUTLIERtest = TRUE, DISTORTIONtest = TRUE, data = never_drink_dat, NbDistribution = 1000,  SignifThreshold = 0.1)

res_presso_never_drink_beta <- res_presso_never_drink[["Main MR results"]][["Causal Estimate"]][[2]]
res_presso_never_drink_or <- exp(res_presso_never_drink_beta)

res_presso_never_drink_or

res_presso_never_drink_se <- res_presso_never_drink[["Main MR results"]][["Sd"]][[2]]/sqrt(nrow(res_presso_never_drink[["MR-PRESSO results"]][["Outlier Test"]]))

res_presso_never_drink_lower_ci = exp(res_presso_never_drink_beta - 1.96*res_presso_never_drink_se)
res_presso_never_drink_lower_ci

res_presso_never_drink_upper_ci = exp(res_presso_never_drink_beta + 1.96*res_presso_never_drink_se)
res_presso_never_drink_upper_ci

#Sensitivity Analysis
never_drink_heterogenity <- mr_heterogeneity(never_drink_dat)
never_drink_pleiotropy <- mr_pleiotropy_test(never_drink_dat)

#plots
#all MR Methods
p1neverdrink <- mr_scatter_plot(res_never_drink, never_drink_dat)
p1neverdrink[1]

# Single SNPs
res_single <- mr_singlesnp(never_drink_dat)
p2 <- mr_forest_plot(res_single)
p2[[1]]
