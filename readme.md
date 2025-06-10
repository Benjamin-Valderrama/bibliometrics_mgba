# **A Bibliometric Analysis of the Microbiome-Gut-Brain axis Field : A Living Article**

#### Authors: [Benjamin Valderrama](https://benjamin-valderrama.github.io/about.html).

#### Last update: June 2025.

------------------------------------------------------------------------

## Abstract

An semi-automated bibliometric analysis of the publications made on the Microbiome-Gut-Brain axis field. Although presented as a paper, it is just a small report made to explore the field I'm working on.

## Introduction

I'm using [this published work](https://pmc.ncbi.nlm.nih.gov/articles/PMC9119018/) as a reference.

## Results and Discussion

#### [Who published all those reviews!?]{.underline}

First, we wanted to explore the number of publications published by year (Figure 1A). In the Microbiome-Gut-Brain axis field, as in any other field, the tendency is to increase the number of original articles and reviews over the years. Note the big red dots representing years where the number of published reviews is at least as high as the number of published research articles (Figure 1A). These are called *'tragic years'*, as the number of research articles is lower than the number of reflective or compilation pieces. Note the lack of tragic years after 2018.

For each *tragic year* we explored the proportion of reviews that were written by the authors that wrote the most reviews across all *tragic years* (Figure 1B). Interestingly, among the six most prolific review authors, four work on the same institution: John F. Cryan, Timothy G. Dinan, Gerard Clarke and Siobhain M. O'Mahony. Moreover, in year 2016, these four authors accounted for the largest proportion of reviews among the *tragic years*, as toghether they contributed with \~23.4% of the total number of reviews in the field.

![**Figure 1: Years with high proportion of reviews and who authored them.** (A) Number of publications per year by publication type.Big red dots represent years where the number of published reviews (pink line) is at least as high as the number of published research articles (gold line). (B) Yearly proportion of reviewers written by the authors who published more reviews (in colors) and other authors (grey).](outputs/mains/figure1.jpg){width="1000" height="640"}

## Strenghts and Limitations

## Conclusion

## Methods

The data was collected using the [Web of science (WoS) search tool](https://www-webofscience-com.ucc.idm.oclc.org/wos/woscc/basic-search). The Search was conducted on the 09th-June-2025, using the following term:

> ((ALL=("microbiota gut brain" OR "microbiotas gut brain" OR "microbiome gut brain" OR "microbiomes gut brain" OR "microbial community gut brain" OR "microbial communities gut brain"))) AND DOP=(1945/2025)

The data was analysed using the [Bibliometrix](https://www.bibliometrix.org/home/) package.
