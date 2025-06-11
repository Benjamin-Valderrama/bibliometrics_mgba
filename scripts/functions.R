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
filter_matrix <- function(matrix, by = "continent", pattern = "|"){
    
    countries_df <- countries
    rownames(countries_df) <- countries_df$countries
    
    # filter by continent
    if( by == "continent"){
        to_keep <- grepl(x = countries_df$continent, pattern = pattern)
        to_keep <- rownames(countries_df)[to_keep]
    }
    
    
    # filter and sort countries of interest
    matrix[rownames(matrix) %in% to_keep, colnames(matrix) %in% to_keep]
    
}