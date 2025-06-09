#' Functions that can be helpful

read_biblio <- function(path){
    path %>% 
        read_xlsx(sheet = "savedrecs") %>% 
        mutate(across(everything(), as.character)) %>% 
        janitor::clean_names()
}
