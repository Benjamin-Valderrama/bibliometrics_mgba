# **A Bibliometric Analysis of the Microbiome-Gut-Brain axis Field : A Living Article**

#### Authors: [Benjamin Valderrama](https://benjamin-valderrama.github.io/about.html).

#### Last update: June 2025.

------------------------------------------------------------------------

## Index

1.  [Abstract](https://github.com/Benjamin-Valderrama/bibliometrics_mgba?tab=readme-ov-file#abstract)
2.  [Introduction](https://github.com/Benjamin-Valderrama/bibliometrics_mgba?tab=readme-ov-file#introduction)
3.  [Methods](https://github.com/Benjamin-Valderrama/bibliometrics_mgba?tab=readme-ov-file#methods)
4.  [Results and Discussion](https://github.com/Benjamin-Valderrama/bibliometrics_mgba?tab=readme-ov-file#results-and-discussion)
        4.1 [Top cited authors and countries, and who they collaborate with](https://github.com/Benjamin-Valderrama/bibliometrics_mgba?tab=readme-ov-file#top-cited-authors-and-countries-and-who-they-collaborate-with)
5.  [Conclusion](https://github.com/Benjamin-Valderrama/bibliometrics_mgba?tab=readme-ov-file#conclusion)
6.  Supplementary material
7.  [References](https://github.com/Benjamin-Valderrama/bibliometrics_mgba?tab=readme-ov-file#references)

------------------------------------------------------------------------

## Abstract

An semi-automated bibliometric analysis of the publications made on the Microbiome-Gut-Brain axis field. Although presented as a paper, it is just a small report made to explore some hypotheses I have about the field I'm working on.

## Introduction

A previous article performed a bibliometrics analysis of the Microbiome-Gut-Brain axis field from 2004 to 2020 [(Wang et al. 2020)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9119018/). Although informative upon publication, the analysis is not longer reflective of the current status of the field, which grows every year. To overcome this limitation, we conducted a new bibliometric analysis here introduced as a live article [REF].

Additionally, previous research has been shown that current microbiome research is skewed towards an overrepresentation of European and North American populations [(Abdill et al. 2022)](https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3001536). Although no exploration has been conducted specifically on the Microbiome-Gut-Brain axis field, I have no reasons to think it would be different.

## Results and Discussion

#### Top cited authors and countries, and who they collaborate with

We wanted to explore large temporal patterns in the Microbiome-Gut-Brain axis field. We first determined the 10 most cited authors (Figure 1A) and the 8 most cited countries (Figure 1B) across all years. There is a clear stability in terms of the most cited authors (Figure 1A), as the top 3 are highly cited across all years. Interestingly, among the most cited authors there are some that were highly cited in one year but their citations drastically dropped after. Regarding the top cited countries, China and the USA are dominating the ranking in the last couple of years as the most and second most cited countries in the field, respectively. Interestingly, although Ireland was in the top 3 most cited countries for more than a decade (Figure 1B), the country is moving down in the ranking to an historic low. In contrast, research from Australia and Belgium have gain citations in the same period.

Next, we wanted to explore the collaboration network of the most influential countries and authors of the field. We selected the most cited countries in the last three years: China (24,952 total citations; 30.4 citations per article on average), Ireland (19,457 total citations, 155.7 citations per article on average) and USA (15,568 total citations, 49.7 citations per article on average). Then, we determined the country-level collaboration networks based on the co authorship across papers in the database. We then plotted the collaboration networks of these most cited countries, with emphasis in how they collaborate across world regions: Asia (Figure 1C), Europe (Figure 1D), Africa (Figure 1E) and South America (Figure 1F).

Not that the top three most cited countries have connections with countries from all world regions. Interestingly, whereas many local collaborations among countries in Asia and Europe (Figure 1C and 1D) were found, local collaborations among African and South American countries (Figure 1E and 1F) are less common.

![**Figure 1: Most cited authors, countries and their collaboration networks.** (A) Top 10 most cited authors over time. Shades of orange show the number of citations per year at the moment of screening. (B) Ranking of the top 8 most cited countries over time. The cumulative number of citations is shown for each year. Each country is a color. (C) collaboration networks of the 3 most cited countries and countries from Asia. (B) Same as A, but with countries from Europe (C) Africa (D) South America. The top 3 most productive countries (China, Ireland and USA) are shown in red. Other countries in grey.](outputs/mains/figure1.jpg)

## Strenghts and Limitations

## Conclusion

## Methods

**Data collection**

The data was collected using the [Web of science (WoS) search tool](https://www-webofscience-com.ucc.idm.oclc.org/wos/woscc/basic-search). The Search was conducted on the 10th of June, 2025. The following query was used:

> ((ALL=("microbiota gut brain" OR "microbiotas gut brain" OR "microbiome gut brain" OR "microbiomes gut brain" OR "microbial community gut brain" OR "microbial communities gut brain"))) AND DOP=(1945/2025)

**Data analysis and ploting**

The data was analysed using the [bibliometrix](https://www.bibliometrix.org/home/) package. Networks were ploted using the [ggnet2](https://briatte.github.io/ggnet/#:~:text=The%20ggnet2%20function%20is%20a,one%2Dmode%20igraph%20network%20objects.) package.

The code used in the analysis and in the generation of figures is publicly available in the script: 'scripts/analysis.R'. Custom functions used to facilitate the analysis can be found in 'scripts/functions.R'.

## References

[Abdill RJ, Adamowicz EM, Blekhman R (2022) Public human microbiome data are dominated by highly developed countries. PLOS Biology 20(2): e3001536. doi: 10.1371/journal.pbio.3001536](https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3001536)

[Wang H, Long T, You J, Li P, Xu Q. Bibliometric Visualization Analysis of Microbiome-Gut-Brain Axis from 2004 to 2020. Med Sci Monit. 2022 May 15;28:e936037. doi: 10.12659/MSM.936037. PMID: 35568968; PMCID: PMC9119018.](https://pmc.ncbi.nlm.nih.gov/articles/PMC9119018/)
