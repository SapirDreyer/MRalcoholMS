
library(TwoSampleMR)
library(readr)
library(dplyr)
library(MRPRESSO)
library(tidyr)

set.seed(1)


## importing exposure data (GWAS of Exposure) - fitting col names to standard of package
drinks_exp_dat <- read_tsv("DrinksPerWeek.txt")
head (drinks_exp_dat)
drinks_exp_datr = dplyr::rename(drinks_exp_dat,'SNP' = RSID, 'effect_allele' = REF, 'other_allele' = ALT, 'beta' = BETA,'pval'=PVALUE,'se'=SE,'eaf'=AF, 'chr'=CHROM)
head (drinks_exp_datr)



# MS GWAS - missing beta and SE -calculation of z score and log(OR) to recover them
ms_chip = readr::read_table('discovery_metav3.0.meta')
ms_chip = dplyr::mutate(ms_chip, 'variant' = paste0(CHR,':',BP))
ms_dat = dplyr::mutate(ms_chip,'z_score' = qnorm(1-(P/2)))
rm(ms_chip)
ms_dat = dplyr::mutate(ms_dat,'logodds' = log(OR))
ms_dat = dplyr::mutate(ms_dat, 'se' = sqrt((logodds/z_score)^2))
ms_dat = dplyr::rename(ms_dat,'effect_allele' = A1, 'other_allele' = A2, 'beta' = logodds,'pval'=P)
ms_dat = dplyr::select(ms_dat,SNP,variant,effect_allele,other_allele,beta,se,pval)
head(ms_dat)


#filter to overlapping SNPs
ms_dat = ms_dat[ms_dat$SNP %in% drinks_exp_datr$SNP,]
drink_exp = drinks_exp_datr[drinks_exp_datr$SNP %in% ms_dat$SNP,]
rm(drinks_exp_datr)
rm(drinks_exp_dat)

exp_sig <- drink_exp %>% dplyr::filter(pval < 5e-8)


#### Format data exposure and outcome
drink_exp = format_data(exp_sig,type='exposure')
ms_dat = format_data(ms_dat,type='outcome')

# clumping- making sure snps are independent of one another based on the IEU GWAS database 

drink_exp <- clump_data(drink_exp)


###########
# harmonise - This creates a new data frame that has the exposure data and outcome data combined.
dat <- harmonise_data(
  exposure_dat = drink_exp, 
  outcome_dat = ms_dat
)

###########
# Perform MR
res <- mr(dat)#, method_list = c('mr_ivw'))
res

OR_res <- generate_odds_ratios(res)

res_presso <- mr_presso(BetaOutcome = "beta.outcome", BetaExposure = "beta.exposure", SdOutcome = "se.outcome", SdExposure = "se.exposure", OUTLIERtest = TRUE, DISTORTIONtest = TRUE, data = dat, NbDistribution = 1000,  SignifThreshold = 0.05)
res_presso

res_presso_beta <- res_presso[["Main MR results"]][["Causal Estimate"]][[2]]
res_presso_or <- exp(res_presso_beta)

res_presso_or

res_presso_se <- res_presso[["Main MR results"]][["Sd"]][[2]]/sqrt(nrow(res_presso[["MR-PRESSO results"]][["Outlier Test"]]))

res_presso_lower_ci = exp(res_presso_beta - 1.96*res_presso_se)
res_presso_lower_ci

res_presso_upper_ci = exp(res_presso_beta + 1.96*res_presso_se)
res_presso_upper_ci
##########
#plots
#all MR Methods
p1 <- mr_scatter_plot(res, dat)
p1[1]

# Single SNPs
res_single <- mr_singlesnp(dat)
p2 <- mr_forest_plot(res_single)
p2[[1]]

#Leave One Out
res_loo <- mr_leaveoneout(dat)
p3 <- mr_leaveoneout_plot(res_loo)
p3[[1]]


###########
#Sensitivity Analysis

heterogenity <- mr_heterogeneity(dat)
pleiotropy <- mr_pleiotropy_test(dat)


######################
