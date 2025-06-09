# Preparation -------------------------------------------------------------

# packages
library(tidyverse)
library(readxl)
library(see)

# import functions
source("scripts/functions.R")


# read data ---------------------------------------------------------------

paths <- list.files(path = "input/", pattern = "xlsx", full.names = TRUE, )

types_of_interest <- c("Review", "Review; Early Access", 
                       "Review; Retracted Publication",
                       
                       "Article", "Article; Early Access",
                       "Article; Retracted Publication",
                       "Article; Proceedings Paper",
                       
                       "Correction",
                       "Letter"
                       )

biblio_data <- map(.x = paths, .f = read_biblio) %>% 
    list_rbind() %>% 
    filter(document_type %in% types_of_interest)


# Articles by year --------------------------------------------------------

pub_type_per_year <- biblio_data %>% 
    count(document_type, publication_year, name = "counts") %>% 
    mutate(publication_year = as.numeric(publication_year)) %>% 
    # An early access review has publication date >2025
    filter(publication_year <= 2025)

pub_type_per_year %>% 
    ggplot(aes(x = publication_year, y = counts, color = document_type)) +

    geom_line() +
    geom_point() + 

    scale_color_okabeito() +
    theme_bv()
