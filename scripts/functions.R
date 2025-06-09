#' Functions that can be helpful

theme_bv <- function(){
        
    theme_bw() +
    theme(
          axis.title = element_text(color = "black"),
          axis.text = element_text(color = "black"),
          
          panel.border = element_rect(color = "black")
          
          )
        
}

read_biblio <- function(path){
    path %>% 
        read_xlsx(sheet = "savedrecs") %>% 
        mutate(across(everything(), as.character)) %>% 
        janitor::clean_names()
}
