
# Libraries ---------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(gt)
library(paletteer)
library(plotly)
library(osmdata)
library(ggmap)
library(tidycensus)
library(htmltools)
library(purrr)

#From OSM
hennepin.box <- osmdata::getbb("hennepin")

#Get the base map (foundational layer)
hennepin.base.map <- get_map(location = hennepin.box,
                             source = "stamen",
                             maptype = "watercolor",
                             crop = TRUE)

my_census_key <- Sys.getenv("census_key")
?Sys.getenv

census_api_key(my_census_key, 
               overwrite = TRUE,
               install = TRUE)

#Call ACS API, return an sf object
hennepin_pop.df <- get_acs(geography = "tract",
                           variables = "B01001_001E", # not necessarily informative, but I don't care at this point
                           state = "MN",
                           county = "Hennepin",
                           year = 2020,
                           geometry = TRUE,
                           cb = FALSE)

# Plot normally
income.gg <- ggplot() + 
  geom_sf(data = hennepin_pop.df, aes(fill = estimate)) + 
  labs(title = "Hennepin County 2020 Estimated Population by Zipcode") + 
  theme_void() + 
  scale_fill_viridis_c("Estimated Population by Zipcode, 2020")

# Display
income.gg
