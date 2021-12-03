# MSalcoholMR
Mendelian Randomization to assess causality between alcohol consumption and multiple sclerosis

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
