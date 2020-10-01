library(tidyverse)
library(jsonlite)
library(janitor)

## To generate this file:
## 1. Navigate to https://lop.parl.ca/sites/ParlInfo/default/en_CA/People/parliamentarians
## 2. Open devtools
## 3. Put in a blank search
## 4. Copy the URL for the XHR request that goes out
## 5. Put that URL in browser, save the response as `data/lop/parliamentarians.json`
## 6. Edit `data/lop/parliamentarians.json` so it's proper JSON (see `load.R` for what we lop off), using HexFiend or similar
parliamentarians_to_download <- read_json("data/source/lop/parliamentarians.json", simplifyVector = TRUE, flatten = TRUE) %>%
  as_tibble %>%
  clean_names

parliamentarian_urls <- parliamentarians_to_download %>%
  select(person_id) %>%
  mutate(url = paste0("https://lop.parl.ca/ParlinfoWebApi/Person/GetPersonWebProfile/", person_id, "?callback=1"))

## Write out to a file
parliamentarian_urls %>%
  select(url) %>%
  write_csv("data/out/parliamentarian-urls.csv", col_names = FALSE)

## In terminal, navigate to `data/members`
## Run this curl: xargs -n 1 curl -O < ../parliamentarian-urls.csv
