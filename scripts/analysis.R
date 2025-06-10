# Preparation -------------------------------------------------------------

# packages
library(tidyverse)
library(readxl)
library(see)

# import functions
source("scripts/functions.R")


# Read data ---------------------------------------------------------------

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
    # an early access review has publication date >2025
    filter(publication_year <= 2025)

# identify years where the number of reviews >= articles
tragic_years <- pub_type_per_year %>% 
    filter(document_type %in% c("Article", "Review")) %>% 
    pivot_wider(names_from = "document_type",
                values_from = "counts") %>% 
    mutate(tragic = ifelse(Review >= Article, yes = TRUE, no = FALSE)) %>% 
    filter(tragic)
    

pub_type_per_year %>% 
    ggplot(aes(x = publication_year, y = counts, color = document_type)) +
    
    geom_line(linewidth = 1, alpha = 0.8) +
    geom_point(size = 2.5, alpha = 0.8) + 
    
    # add tragic years: years with less articles than reviews published
    geom_point(data = tragic_years, inherit.aes = FALSE,
               aes(x = publication_year, y = Review),
               color = "tomato3",
               size = 5) +
    
    labs(x = "Year", y = "Number of publications", color = "Publication type") +
    
    # use as few hardcoded variables as possible
    scale_x_continuous(limits = c(min(pub_type_per_year$publication_year) - 1 ,
                                  max(pub_type_per_year$publication_year) + 1
                                  ),
                       expand = c(0,0),
                       breaks = seq(from = min(pub_type_per_year$publication_year),
                                    to = max(pub_type_per_year$publication_year),
                                    by = 3)
                       ) +
    
    scale_y_continuous(limits = c(- 5 , max(pub_type_per_year$counts) + 10),
                       expand = c(0,0),
                       breaks = seq(from = 0,
                                    to = max(pub_type_per_year$counts), 
                                    length.out = 10)
                       ) +
    
    scale_color_okabeito() +
    
    theme_bv()


ggsave(filename = "outputs/pubs_over_years.jpg", height = 4, width = 6)


# Who wrote so many reviews? ----------------------------------------------

review_authors_in_tragic_years <- biblio_data %>% 
    filter(publication_year %in% tragic_years$publication_year) %>% 
    filter(document_type == "Review") %>% 
    select(author = author_full_names, publication_year, article_title) %>% 
    separate_longer_delim(author, delim = ";") %>% 
    mutate(author = str_trim(author))


top_10 <- review_authors_in_tragic_years %>% 
    count(author, name = "counts") %>% 
    slice_max(order_by = counts, n = 5) %>% 
    pull(author) %>% 
    rev()

review_authors_in_tragic_years %>% 
    mutate(author = ifelse(author %in% top_10, yes = author, no = "Other"),
           author = factor(x = author, level = c("Other", top_10))) %>% 
    count(author, publication_year, name = "counts") %>% 
    mutate(prop = counts/sum(counts) * 100, .by = c(publication_year)) %>% 
    ggplot(aes(x = publication_year, y = prop, fill = author)) +
    
    geom_col() +
    
    labs(x = "Tragic years", 
         y = "Proportion of reviews per Author",
         fill = "Author") +
    
    scale_fill_okabeito(order = c(8, 1:length(top_10))) +
    
    scale_x_discrete(expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0)) +
    
    theme_bv()

ggsave(filename = "outputs/prop_authors_on_tragic_years.jpg", height = 4, width = 6)


#' Are these authors that published a lot of reviews early in the field central 
#' in the field network?