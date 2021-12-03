
library(TwoSampleMR)
library(readr)
library(dplyr)
library(MRPRESSO)
library(tidyr)

set.seed(1)
# MR AUDIT UKB

## importing exposure data (GWAS of Exposure) - fitting col names to standard of package
UKB_data_file <- read_table("AUDIT_UKB_2018_AJP.txt")
head (UKB_data_file)
UKB_data = dplyr::rename(UKB_data_file,'SNP' = rsid, 'effect_allele' = a_1, 'other_allele' = a_0, 'beta' = beta_T,'pval'=p_T,'se'=se_T)
head (UKB_data)
rm(UKB_data_file)



# MS GWAS - missing beta and SE -calculation of z score and log(OR) to recover them
ms_chip_ukb = readr::read_table('discovery_metav3.0.meta')
ms_chip_ukb = dplyr::mutate(ms_chip_ukb, 'variant' = paste0(CHR,':',BP))
ms_dat_ukb = dplyr::mutate(ms_chip_ukb,'z_score' = qnorm(1-(P/2)))
rm(ms_chip_ukb)
ms_dat_ukb = dplyr::mutate(ms_dat_ukb,'logodds' = log(OR))
ms_dat_ukb = dplyr::mutate(ms_dat_ukb, 'se' = sqrt((logodds/z_score)^2))
ms_dat_ukb = dplyr::rename(ms_dat_ukb,'effect_allele' = A1, 'other_allele' = A2, 'beta' = logodds,'pval'=P)
ms_dat_ukb = dplyr::select(ms_dat_ukb,SNP,variant,effect_allele,other_allele,beta,se,pval)
head(ms_dat_ukb)


#filter to overlapping SNPs
ms_dat_ukb = ms_dat_ukb[ms_dat_ukb$SNP %in% UKB_data$SNP,]
UKB_data = UKB_data[UKB_data$SNP %in% ms_dat_ukb$SNP,]

UKB_data_sig <- UKB_data %>% dplyr::filter(pval < 5e-8)

#### Format data exposure and outcome
UKB_exp = format_data(UKB_data_sig,type='exposure')
ms_out_ukb = format_data(ms_dat_ukb,type='outcome')

# clumping- making sure snps are independent of one another based on the IEU GWAS database 
UKB_exp <- clump_data(UKB_exp)


# harmonise - This creates a new data frame that has the exposure data and outcome data combined.
ukb_dat <- harmonise_data(
  exposure_dat = UKB_exp, 
  outcome_dat = ms_out_ukb
)

# Perform MR
res_ukb <- mr(ukb_dat)#, method_list = c('mr_ivw'))

OR_res_ukb <- generate_odds_ratios(res_ukb)


p1ukb <- mr_scatter_plot(res_ukb, ukb_dat)
p1ukb[1]

res_single_ukb <- mr_singlesnp(ukb_dat)
p2_ukb <- mr_forest_plot(res_single_ukb)
p2_ukb[[1]]



res_presso_ukb <- mr_presso(BetaOutcome = "beta.outcome", BetaExposure = "beta.exposure", SdOutcome = "se.outcome", SdExposure = "se.exposure", OUTLIERtest = TRUE, DISTORTIONtest = TRUE, data = ukb_dat, NbDistribution = 1000,  SignifThreshold = 0.05)
res_presso_ukb_beta <- res_presso_ukb[["Main MR results"]][["Causal Estimate"]][[2]]
res_presso_ukb_or <- exp(res_presso_ukb_beta)

res_presso_ukb_or

res_presso_ukb_se <- res_presso_ukb[["Main MR results"]][["Sd"]][[2]]/sqrt(nrow(res_presso_ukb[["MR-PRESSO results"]][["Outlier Test"]]))

res_presso_ukb_lower_ci = exp(res_presso_ukb_beta - 1.96*res_presso_ukb_se)
res_presso_ukb_lower_ci

res_presso_ukb_upper_ci = exp(res_presso_ukb_beta + 1.96*res_presso_ukb_se)
res_presso_ukb_upper_ci


heterogenity_ukb <- mr_heterogeneity(ukb_dat)
pleiotropy_ukb <- mr_pleiotropy_test(ukb_dat)



