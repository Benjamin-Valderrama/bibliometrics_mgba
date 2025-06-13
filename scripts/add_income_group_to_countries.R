
#' We will make a clean dataset with information for each country:
#' 
#' I have two sources of information: 
#' 
#' 1) From the bibliometrix package, I just want the country names. as I need to match how they use
#' it for other analyses.
#' 
#' 2) From the world bank, I want the income and world region of each country.
#' 
#' So, what I want to have is the name of the country as in bibliometrix and the world region
#' and income of each country as in world bank


library(tidyverse)

wb_data <- readxl::read_xlsx(path = "input/worldbank2025_countries_income.xlsx") %>% 
    janitor::clean_names() %>% 
    rename(countries = economy) %>% 
    select(countries, income_group)

biblio_data <- bibliometrix::countries %>% 
    # to match the format of country names in WB
    mutate(countries = str_to_title(countries))

nrow(wb_data) ; nrow(biblio_data)


shared <- base::intersect(wb_data$countries, biblio_data$countries)
diffs_wb <- base::setdiff(wb_data$countries, biblio_data$countries);diffs_wb %>% sort()
diffs_biblio <- base::setdiff(biblio_data$countries, wb_data$countries);diffs_biblio %>% sort()

# Manual fix of country names
wb_data_fixed <- wb_data %>% 
    mutate(countries = case_when(grepl(x = countries, pattern = "Egypt, Arab Rep.") ~ "Egypt",
                                 grepl(x = countries, pattern = "Bahamas, The") ~ "Bahamas",
                                 grepl(x = countries, pattern = "Bosnia and Herzegovina") ~ "Bosnia",
                                 grepl(x = countries, pattern = "Brunei Darussalam") ~ "Brunei",
                                 grepl(x = countries, pattern = "Congo, Rep.") ~ "Congo",
                                 grepl(x = countries, pattern = "Côte d'Ivoire") ~ "Cote D'ivoire",
                                 grepl(x = countries, pattern = "Czechia") ~ "Czech Republic",
                                 grepl(x = countries, pattern = "Egypt, Arab Rep.") ~ "Egypt",
                                 grepl(x = countries, pattern = "Faroe Islands") ~ "Faroe",
                                 grepl(x = countries, pattern = "Gambia, The") ~ "Gambia",
                                 grepl(x = countries, pattern = "Iran, Islamic Rep.") ~ "Iran",
                                 grepl(x = countries, pattern = "Korea, Dem. People's Rep.") ~ "Korea",
                                 grepl(x = countries, pattern = "Korea, Rep.") ~ "North Korea",
                                 grepl(x = countries, pattern = "Kyrgyz Republic") ~ "Kyrgyzstan",
                                 grepl(x = countries, pattern = "Lao PDR") ~ "Laos",
                                 grepl(x = countries, pattern = "North Macedonia") ~ "Macedonia",
                                 grepl(x = countries, pattern = "Micronesia, Fed. Sts.") ~ "Micronesia",
                                 grepl(x = countries, pattern = "Russian Federation") ~ "Russia",
                                 grepl(x = countries, pattern = "St. Kitts and Nevis") ~ "Saint Kitts And Nevis",
                                 grepl(x = countries, pattern = "St. Lucia") ~ "Saint Lucia",
                                 grepl(x = countries, pattern = "São Tomé and Príncipe") ~ "Sao Tome And Principe",
                                 grepl(x = countries, pattern = "Slovak Republic") ~ "Slovakia",
                                 grepl(x = countries, pattern = "Syrian Arab Republic") ~ "Syria",
                                 grepl(x = countries, pattern = "Taiwan, China") ~ "Taiwan",
                                 grepl(x = countries, pattern = "Trinidad and Tobago") ~ "Trinidad And Tobago",
                                 grepl(x = countries, pattern = "Türkiye") ~ "Turkey",
                                 grepl(x = countries, pattern = "United Arab Emirates") ~ "U Arab Emirates",
                                 grepl(x = countries, pattern = "United States") ~ "Usa",
                                 grepl(x = countries, pattern = "Venezuela, RB") ~ "Venezuela",
                                 grepl(x = countries, pattern = "Yemen, Rep.") ~ "Yemen",
                                 T ~ countries
                                 )
           )

# Manual fix of income groups
biblio_extended <- left_join(x = biblio_data, y = wb_data_fixed, by = "countries") %>% 
        mutate(income_group = case_when(countries == "England" ~ "High income",
                                        countries == "United States" ~ "High income",
                                        countries == "United Arab Emirates" ~ "High income",
                                        countries == "Hong Kong" ~ "High income",
                                        T ~ income_group))

biblio_extended %>% 
    filter(is.na(income_group)) 


# export to tmp
write_tsv(x = biblio_extended,
          file = "tmps/countries_extended.tsv")
