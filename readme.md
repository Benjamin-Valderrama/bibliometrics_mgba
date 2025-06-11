# **A Bibliometric Analysis of the Microbiome-Gut-Brain axis Field : A Living Article**

#### Authors: [Benjamin Valderrama](https://benjamin-valderrama.github.io/about.html).

#### Last update: June 2025.

------------------------------------------------------------------------

## Index

1.  [Abstract](##Abstract)
2.  [Introduction](##Introduction)
3.  [Methods](##Methods)
4.  [Results and Discussion](##Results-and-Discussion)
5.  [Conclusion](##Conclusion)
6.  Supplementary material
7.  [References](##References)

------------------------------------------------------------------------

## Abstract

An semi-automated bibliometric analysis of the publications made on the Microbiome-Gut-Brain axis field. Although presented as a paper, it is just a small report made to explore some hypotheses I have about the field I'm working on.

## Introduction

I'm using this published work by [(Wang et al. 2020)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9119018/) as a reference.

## Results and Discussion

First, we wanted to explore the country-level collaboration network. We first identified the top three most cited countries: China (24,952 total citations; 30.4 citations per article on average), Ireland (19457 total citations, 155.7 citations per article on average) and USA (15,568 total citations, 49.7 citations per article on average). Then, we estimated the country-level collaboration networks based on the co authorship across papers in the database. We then plotted the collaboration of the top three most cited countries with other countries from other world regions: Asia (Figure 1A), Europe (Figure 1B), Africa (Figure 1C) and South America (Figure 1D).

![Collaboration networks between the 3 most productive countries and other world regions. (A) Asia (B) Europe (C) Africa (D) South America. The top 3 most productive countries (China, Ireland and USA) are shown in red. Other countries in grey.](outputs/mains/country_collab.jpg)

## Strenghts and Limitations

## Conclusion

## Methods

**Data collection**

The data was collected using the [Web of science (WoS) search tool](https://www-webofscience-com.ucc.idm.oclc.org/wos/woscc/basic-search). The Search was conducted on the 10th of June, 2025. The following query was used:

> ((ALL=("microbiota gut brain" OR "microbiotas gut brain" OR "microbiome gut brain" OR "microbiomes gut brain" OR "microbial community gut brain" OR "microbial communities gut brain"))) AND DOP=(1945/2025)

**Data analysis and ploting**

The data was analysed using the [bibliometrix](https://www.bibliometrix.org/home/) package. Networks were ploted using the [ggnet2](https://briatte.github.io/ggnet/#:~:text=The%20ggnet2%20function%20is%20a,one%2Dmode%20igraph%20network%20objects.) package.

All code used in the analysis and to produce the figures is publicly available in the script: 'scripts/analysis.R'. Custom functions used to facilitate the analysis can be found in 'scripts/functions.R'.

## References

[Wang H, Long T, You J, Li P, Xu Q. Bibliometric Visualization Analysis of Microbiome-Gut-Brain Axis from 2004 to 2020. Med Sci Monit. 2022 May 15;28:e936037. doi: 10.12659/MSM.936037. PMID: 35568968; PMCID: PMC9119018.](https://pmc.ncbi.nlm.nih.gov/articles/PMC9119018/)
