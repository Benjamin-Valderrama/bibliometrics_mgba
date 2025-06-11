#' Functions that can be helpful

# custom theme function
theme_bv <- function(){
        
    theme_bw() +
    theme(
          axis.title = element_text(color = "black"),
          axis.text = element_text(color = "black"),
          
          panel.border = element_rect(color = "black")
          
          )
        
}

# read the WoS exported results from xlsx files
read_biblio <- function(path){
    path %>% 
        readxl:read_xlsx(sheet = "savedrecs") %>% 
        mutate(across(everything(), as.character)) %>% 
        janitor::clean_names()
}

# filter a bibliographic network (matrix) by a column
filter_matrix <- function(matrix, by = NULL, pattern = "|"){
    
    # modified bibliometrix::countries data frame
    countries_df <- countries
    rownames(countries_df) <- countries_df$countries
    
    # check arguments
    if(is.null(by)){
        .by_list <- c("'country', 'continent'")
        stop(paste("Argument 'by' is empty. Select from:", .by_list))
    }
    
    # filter by continent
    if( by == "continent"){
        to_keep <- grepl(x = countries_df$continent, pattern = pattern)
        to_keep <- rownames(countries_df)[to_keep]
    }
    
    # filter by country 
    if( by == "country"){
        to_keep <- grepl(x = rownames(countries_df), pattern = pattern)
        to_keep <- rownames(countries_df)[to_keep]
    }
    
    # filter and sort countries of interest
    matrix[rownames(matrix) %in% to_keep, colnames(matrix) %in% to_keep]
    
}

plot_topn_with_continent <- function(network, summary, topn, continent, seed = 1997){
    
    #' Make a vector with countries to plot using:
    #' the top N cited + other countries of interest
    topn_cited_countries <- summary$TCperCountries[1:topn, 1] %>% str_trim()
    other_countries <- countries[countries$continent == continent, "countries"]
    countries_to_plot <- paste(c(topn_cited_countries, other_countries), collapse = "|")

    # custom function to subset countries of interest
    small_network <- filter_matrix(network,
                                   by = "country",
                                   pattern = countries_to_plot)
    
    # add custom colors to plot
    # NOTE: the no_topn are determined here as not all countries from 'other_countries'
    # appear in the network used within 'filter_matrix'
    no_topn <- colnames(small_network)[!colnames(small_network) %in% topn_cited_countries]
    my_colors <- c(
                   rep("tomato3", length(topn_cited_countries)),
                   rep("grey", length(no_topn))
                   )

    set.seed(seed)
    # return a plot
    ggnet2(small_network, 
           mode = "circle",
           color = my_colors,
           label = TRUE)
}
