library(tictoc)
library(tibble)
library(cheese)

tic()
source(c("crawl.R", "utils.R", "zzz.R"))

cheese_letters <- cheese_get_labels(i="a", page=1, tag="i")
cheese_pages <- lapply(cheese_letters, function(i) cheese_get_labels(i=i, page=1, tag="page"))

cheese_num_pages <- lapply(cheese_pages, function(x) ifelse(length(x)>0, max(as.numeric(x), na.rm = TRUE), 1))

letter_pages_df <- tibble::tibble(
    i=rep.int(x=cheese_letters, times=cheese_num_pages),
    page=unlist(lapply(cheese_num_pages, seq.int))
  )

gallery_df <- purrr::pmap_dfr(letter_pages_df, cheese_parse_gallery, verbose=TRUE)

#readr::write_csv(gallery_df, "cheese_gallery.csv")
#readr::write_rds(gallery_df, "cheese_gallery.Rds")

toc()
#58.72 sec elapsed
dim(gallery_df)
#[1] 1830    2


tic()
library(dplyr)
library(tidyr)
library(lettercase)
cheese_raw <- purrr::pmap_dfr(gallery_df, cheese_parse_page, verbose=TRUE)
names(cheese_raw) <- gsub("cheese_", "", names(cheese_raw))

cheese <- cheese_raw %>%
  mutate(summary=purrr::map(summary, as_tibble)) %>%
  mutate(summary=purrr::map(summary, separate,
                                   col="value",
                                   into=c("tag", "content"),
                                   sep=": ", extra="merge", fill="left")) %>%
  unnest(summary) %>%
  mutate_all(funs(trimws)) %>%
  mutate(tag=tolower(make_names(tag))) %>%
  spread(key=tag, value = content)

#readr::write_csv(cheese, "cheese.csv")
#readr::write_rds(cheese, "cheese.Rds")

toc()
#3550 sec elapsed
dim(cheese)
#[1] 1830   21
