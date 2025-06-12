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


# Read data in ------------------------------------------------------------

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


# Most cited authors over time --------------------------------------------

# top most influential authors (all documents)
authors_df <- biblio %>% 
    select(UT, AU, PY, TC) %>% 
    separate_longer_delim(AU, delim = ";") %>% 
    # get number of pubs and citations by author and year
    summarise(publications = n(),
              citations = sum(TC, na.rm = TRUE),
              .by = c(PY, AU)) %>% 
    filter(publications > 2) %>% 
    # add columns with total pubs (across years) by author 
    mutate(total_citations = sum(citations), 
           total_publications = sum(publications), .by = AU) %>% 
    # add column for the axis of the plot
    mutate(AU_w_details = paste0(AU, "\n(Total cits:", total_citations, "\n",
                                 "Total pubs:", total_publications, ")"))

top_authors_ordered <- authors_df %>% 
    select(total_citations, AU_w_details) %>% 
    # because we used mutate in 'authors_df', we need to remove the repeated rows
    unique() %>% 
    slice_max(n = 10, order_by = total_citations, with_ties = TRUE) %>% 
    pull(AU_w_details)

# results as heatmap
top_authors_df <- authors_df %>% 
    filter(AU_w_details %in% top_authors_ordered) %>% 
    mutate(AU_w_details = factor(AU_w_details, 
                                 levels = rev(top_authors_ordered)))

breaks <- seq(from = 1e3,
              to = (round(max(top_authors_df$citations)/1e3)) * 1e3,
              by = 1e3)
low_range <- paste0(c(breaks[1:length(breaks) -1] - 999), "-")
low_range <- c(low_range, ">")
labels <- paste0(low_range, breaks)


plot_top_cited_authors <- top_authors_df %>% 
    pivot_wider(id_cols = c(AU, AU_w_details, total_citations, total_publications),
                names_from = PY, values_from = citations, values_fill = 0) %>% 
    pivot_longer(cols = starts_with("20"),
                 names_to = "PY", values_to = "citations") %>% 
    mutate(PY = as.numeric(PY)) %>% 
    ggplot(aes(x = PY, y = AU_w_details)) +
    
    geom_tile(aes(fill = citations), color = "black") +
    
    # # add line for the last 3 years: 
    # # Note that the .5 is used to correctly place the line in the plot
    # geom_vline(xintercept = max(top_authors_df$PY) - 3.5,
    #            linewidth = 1.25,
    #            linetype = "4141") +
    
    labs(x = "Years", 
         y = "Most cited authors",
         fill = "Number of\ncitations") +
    
    scale_fill_continuous(high = "#E75E00", low = "#ffeeb9", 
                          na.value = "white",
                          limits = c(1,
                                     max(authors_df$citations)),
                          breaks = breaks,
                          labels = labels
    ) +
    
    scale_x_continuous(expand = c(0,0), 
                       breaks = seq(min(authors_df$PY),
                                    max(authors_df$PY),
                                    by = 2)) +
    scale_y_discrete(expand = c(0,0)) +
    
    guides(fill = guide_legend(override.aes = list(linewidth = 0.75))) +
    
    theme_bv() +
    theme(panel.grid.major = element_blank()); plot_top_cited_authors

ggsave(file = "outputs/top_authors.jpg", 
       plot = plot_top_cited_authors,
       height = 6, width = 7)

#

# Most cited countries over time ------------------------------------------

# get country info for each author
countries_df <- metaTagExtraction(biblio, Field = "AU_CO", sep = ";")

# papers published for each country across all years
countries_by_year <- countries_df %>% 
    select(UT, AU_CO, TC, PY) %>% 
    separate_longer_delim(cols = AU_CO, delim = ";") %>% 
    unique() %>% 
    summarise(publications = n(),
              citations = sum(TC, na.rm = TRUE),
              .by = c(PY, AU_CO)) %>% 
    filter(!is.na(AU_CO))

# get years to plot
valid_years <- countries_by_year %>% 
    summarise(total_countries = n(), .by = PY) %>% 
    filter(total_countries > 3) %>% 
    pull(PY)

# get countries to plot
top_countries <- countries_by_year %>% 
    filter(PY %in% valid_years) %>% 
    summarise(total_citations = sum(citations), .by = AU_CO) %>% 
    slice_max(n = 8, order_by = total_citations) %>% 
    pull(AU_CO)

# dataframe to plot
top_countries_df <- countries_by_year %>% 
    filter(PY %in% valid_years) %>% 
    filter(AU_CO %in% top_countries) %>% 
    mutate(rank = rank(citations, ties.method = "max"), .by = PY) %>% 
    mutate(AU_CO = factor(x = AU_CO, levels = rev(top_countries)))

plot_top_cited_countries <- top_countries_df %>% 
    
    ggplot(aes(x = PY, y = rank, color = AU_CO)) +
    
    geom_line(linewidth = 1.5, show.legend = FALSE, alpha = 0.8) +
    
    geom_point(size = 4.5, alpha = 0.8) +
    geom_point(size = 1.5, color = "#fffff0") +
    
    scale_y_continuous(limits = c(1, 8),
                       breaks = seq(1, 8, by = 1),
                       labels = rev(seq(1, 8, by = 1))) +
    
    scale_x_continuous(limits = c(min(valid_years),
                                  max(valid_years)),
                       
                       breaks = seq(min(valid_years),
                                    max(valid_years),
                                    by = 2)
    ) +
    labs(x = "Year",
         y = "Most cited countries (Ranking)",
         color = "Country") +
    
    scale_color_okabeito() +
    theme_bv() +
    theme(); plot_top_cited_countries


ggsave(file = "outputs/top_countries.jpg", 
       plot = plot_top_cited_countries,
       height = 5, width = 6)





# Collaboration networks of the most cited countries ----------------------

# get a summary of the field
field_analysis <- biblioAnalysis(biblio); field_analysis
field_summary <- summary(field_analysis); field_summary

# collaboration network of those countries
M <- metaTagExtraction(biblio, Field = "AU_CO", sep = ";")
net_matrix <- biblioNetwork(M,
                            analysis = "collaboration", 
                            network = "countries", sep = ";")


# use custom function to make country collaboration graphs
df <- tibble(continent = unique(countries$continent))
df_plots <- df %>% 
    mutate(collab_plot = map(.x = continent, 
                             .f = ~plot_topn_with_continent(network = net_matrix,
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




# Figure 1 ----------------------------------------------------------------

plot_top_cited_authors + plot_top_cited_countries + 
    plot_annotation(tag_levels = "A") &
    theme(plot.tag = element_text(size = 20, face = "bold"))

ggsave(filename = "outputs/mains/most_cited_authors_and_countries.jpg",
       height = 6, width = 14)