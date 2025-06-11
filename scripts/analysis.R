# Preparation -------------------------------------------------------------

# packages
library(tidyverse)
library(bibliometrix)
library(see)
library(patchwork)
library(ggnet)
library(network)
library(sna)

# import functions
source("scripts/functions.R")

#

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
    

plot_pubs_over_years <- pub_type_per_year %>% 
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
    
    theme_bv() + 
    theme(legend.position = "inside",
          legend.position.inside = c(0.35, 0.8)
          ); plot_pubs_over_years


ggsave(filename = "outputs/pubs_over_years.jpg", 
       plot = plot_pubs_over_years,
       height = 4, width = 6)



# Who wrote so many reviews?
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

# Authors may have full names or initials, so these proportions are understimated.
prop_review_authors_in_tragic_years <- review_authors_in_tragic_years %>% 
    mutate(author = ifelse(author %in% top_10, yes = author, no = "Other"),
           author = factor(x = author, level = c("Other", top_10))) %>% 
    count(author, publication_year, name = "counts") %>% 
    mutate(prop = counts/sum(counts) * 100, .by = c(publication_year))

plot_prop_review_authors <- prop_review_authors_in_tragic_years %>% 
    ggplot(aes(x = publication_year, y = prop, fill = author)) +
    
    geom_col() +
    
    labs(x = "Tragic years", 
         y = "Proportion of reviews per author",
         fill = "Author") +
    
    scale_fill_okabeito(order = c(8, 1:length(top_10))) +
    
    scale_x_discrete(expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0), 
                       breaks = seq(0, 100, by = 20), 
                       labels = paste0(seq(0, 100, by = 20), "%")) +
    
    theme_bv(); plot_prop_review_authors

ggsave(filename = "outputs/prop_authors_on_tragic_years.jpg", 
       plot_prop_review_authors,
       height = 4, width = 6)



# Put plots together
figure1 <- plot_pubs_over_years + plot_prop_review_authors + 
    plot_annotation(tag_levels = "A") &
    theme(plot.tag = element_text(size = 20, face = "bold")); figure1

ggsave(filename = "outputs/mains/figure1.jpg",
       plot = figure1, height = 8, width = 10)



# Interaction between world regions ---------------------------------------

#' I found the 'bibliometrix' package that looks very helpful in facilitating
#' some analyses. I'll do this part of the analysis using it.
#' Thus, we overwrite the variables below. Usually I avoid doing this but 
paths <- list.files(path = "input/", pattern = "txt", full.names = TRUE)

biblio <- map(.x = paths, .f = convert2df) %>% 
    mergeDbSources() %>% 
    #' For some reason, `mergeDbSources` forces all CRs to be NAs.
    #' The information, however, is stored in CR_raw:
    #' https://github.com/massimoaria/bibliometrix/blob/146673c3e773b47a69dac6b9e971e09e18af9495/R/mergeDbSources.R#L56
    mutate(CR = CR_raw)

# check missing CRs
missingData(biblio)

# get a summary of the field
field_analysis <- biblioAnalysis(biblio); field_analysis
field_summary <- summary(field_analysis); field_summary

# collaboration network of those countries
M <- metaTagExtraction(biblio, Field = "AU_CO", sep = ";")
NetMatrix <- biblioNetwork(M, 
                           analysis = "collaboration", 
                           network = "countries", sep = ";")


df <- tibble(continent = unique(countries$continent))

# use custom function to make country collaboration graphs
df_plots <- df %>% 
    mutate(collab_plot = map(.x = continent, 
                             .f = ~plot_topn_with_continent(network = NetMatrix,
                                                            summary = field_summary,
                                                            topn = 3,
                                                            seed = 1,
                                                            continent = .x)))

# wrap plots together
plots_country_collab_graphs <- df_plots %>% 
    filter(continent %in% c("AFRICA", "EUROPE", "SOUTH AMERICA", "ASIA")) %>% 
    pull(collab_plot) %>% 
    wrap_plots() + 
    plot_layout(nrow = 2) +
    plot_annotation(tag_levels = "A") &
    theme(plot.tag = element_text(size = 20, face = "bold")); plots_country_collab_graphs

ggsave(filename = "outputs/mains/country_collab.jpg",
       plot = plots_country_collab_graphs,
       height = 8, width = 16)
    



# # get the top 3 most cited countries + countries from other region
# top3_cited_countries <- field_summary$TCperCountries[1:3, 1] %>% str_trim()
# other_countries_to_plot <- countries[countries$continent == "SOUTH AMERICA", "countries"]
# countries_of_interest <- paste(c(top3_cited_countries, countries_to_plot), collapse = "|")
# 
# # custom function to only keep countries from SOUTH AMERICA and EUROP
# top3_coutries_of_interest_matrix <- filter_matrix(NetMatrix, 
#                                                   by = "country",
#                                                   pattern = countries_of_interest)
# 
# no_top_3 <- colnames(top3_coutries_of_interest_matrix)[!colnames(top3_coutries_of_interest_matrix) %in% top3_cited_countries]
# 
# my_colors <- c(rep("tomato3", length(top3_cited_countries)),
#                rep("grey", length(no_top_3))
#                )
# 
# ggnet2(top3_coutries_of_interest_matrix,
#        color = my_colors,
#        label = TRUE)



# # add colors
# my_counties <- countries
# rownames(my_counties) <- countries$countries
# my_counties <- my_counties[colnames(sa_europe_matrix), ]
# continents <- my_counties[colnames(sa_europe_matrix), "continent"]
# my_colors <- ifelse(grepl(x = continents, pattern = "SOUTH AMERICA"),
#                     "tomato3",
#                     "grey")
# 
# south_america_europe <- ggnet2(sa_europe_matrix,
#        color = my_colors,
#        mode = "target",
#        label = TRUE)




# Other -------------------------------------------------------------------

#' Are these authors that published a lot of reviews early in the field central 
#' in the field network?
#' 