## barrel trading
barrel_urls <- c("http://www.cheesereporter.com/Prices/BarrelDetails/2018CheeseBarrelDetails.htm",
"http://www.cheesereporter.com/Prices/BarrelDetails/2017CheeseBarrelDetails.htm",
"http://www.cheesereporter.com/Prices/BarrelDetails/2016CheeseBarrelDetails.htm",
"http://www.cheesereporter.com/Prices/BarrelDetails/2015CheeseBarrelDetails.htm",
"http://www.cheesereporter.com/Prices/BarrelDetails/2014CheeseBarrelDetails.htm",
"http://www.cheesereporter.com/Prices/BarrelDetails/2013CheeseBarrelDetails.htm",
"http://www.cheesereporter.com/Prices/BarrelDetails/2012CheeseBarrelDetails.htm",
"http://www.cheesereporter.com/Prices/BarrelDetails/2011CheeseBarrelDetails.htm")


block_urls <-c("http://www.cheesereporter.com/Prices/Block%20Details/2018CheeseBlockDetails.htm",
"http://www.cheesereporter.com/Prices/Block%20Details/2017CheeseBlockDetails.htm",
"http://www.cheesereporter.com/Prices/Block%20Details/2016CheeseBlockDetails.htm",
"http://www.cheesereporter.com/Prices/Block%20Details/2015CheeseBlockDetails.htm",
"http://www.cheesereporter.com/Prices/Block%20Details/2014CheeseBlockDetails.htm",
"http://www.cheesereporter.com/Prices/Block%20Details/2013CheeseBlockDetails.htm",
"http://www.cheesereporter.com/Prices/Block%20Details/2012CheeseBlockDetails.htm",
"http://www.cheesereporter.com/Prices/Block%20Details/2011CheeseBlockDetails.html")


#http://www.cheesereporter.com/prices.htm
#http://www.cheesereporter.com/cheesepricearchives.htm
#http://www.cheesereporter.com/Prices/2018/2018cheesepricearchives.htm
#http://www.cheesereporter.com/Prices/2017/2017cheesepricearchives.htm
#http://www.cheesereporter.com/Prices/2016cheesepricearchives.htm
#http://www.cheesereporter.com/Prices/2015cheesepricearchives.htm
#http://www.cheesereporter.com/cheeseaverages.htm

library(polite)
library(rvest)
library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
library(readr)
library(stringr)

session <- bow("http://www.cheesereporter.com/")

grab_tables <- function(url, bow, header=NA){
  session <- nod(bow, url)
  session %>%
    scrape() %>%
    html_nodes("table") %>%
    html_table(header=header)
}

categories <- c("Cheddar Block, 40lb", "Cheddar Barrel, 500lb")

avg_url <- "http://www.cheesereporter.com/cheeseaverages.htm"
avg_tlst <- grab_tables(avg_url, session, header=TRUE) %>%
  setNames(categories)
month_abb <- avg_tlst[[1]] %>% colnames() %>% tail(-1) %>% head(-1)

cheese_price <- map_dfr(avg_tlst, ~.x %>%
          gather(key=month, value=price, -Year, convert = TRUE) %>%
          filter(month!="Average") %>%
          mutate(month=factor(month, levels=month_abb),
                 month_num=as.numeric(month),
                 m_date = as.Date(paste(Year, month_num, 1, sep="-"))), .id = "category") %>%
  select(category, date=m_date, price)

cheese_price %>%
  ggplot()+
  geom_line(mapping = aes(x=date, y=price, color=category))

bar_lst <- barrel_urls %>%
  map(grab_tables, session, header=TRUE)

blk_lst <- block_urls %>%
  map(grab_tables, session, header=TRUE)

bar_lst %>% map(~map(.x, names))
blk_lst %>% map_chr(map, names)

tbl_cols <- c("month_day", "price", "volume", "deals", "bids", "offers")

periods <- c(2018:2011)

format_table <- function(lst){
  map(lst, set_names, tbl_cols) %>%
  map_dfr(mutate, volume=as.numeric(volume)) %>%
  as_tibble() %>%
  filter(!(deals=="" & bids =="" & offers=="")) %>%
  filter(!str_detect(tolower(deals), "trading")) %>%
  filter(!str_detect(tolower(price), "avg")) %>%
  separate(month_day, into=c("month", "day"), sep="\\s", extra="merge") %>%
  mutate(price=parse_number(price)) %>%
  filter(!is.na(price)) %>%
  mutate_at(vars(deals:offers), na_if, "None") %>%
  mutate_at(vars(deals:offers), str_remove_all, "[\\n]+$")
  }

parse_nested_deals <- function(.x){
   str_split(.x, "\\n") %>% .[[1]] %>%
      tibble::enframe(name=NULL) %>%
      mutate(value=str_remove_all(trimws(value), "\\s[A-Za-z]+\\s(?=\\@)")) %>%
      separate(value, into=c("volume", "price_flag"), sep="\\@",
               extra="merge") %>%
    mutate(volume=trimws(volume),
           price_flag=str_replace_all(price_flag, "\\$|\\)", ""),
           price_flag=str_replace_all(price_flag, "\\(", " "),
           price_flag=trimws(price_flag)) %>%
    separate(price_flag, into=c("price", "flag"), sep = "\\s+",
             fill="right", extra="merge")
}


bar_df <- bar_lst %>%
  set_names(periods) %>%
  map_dfr(format_table, .id="year") %>%
  mutate_at(vars(year, day), as.numeric) %>%
  mutate_at(vars(deals:offers), map, parse_nested_deals) %>%
  mutate(category="Cheddar Barrel, 500lb")

blk_df <- blk_lst %>%
  set_names(periods) %>%
  map_dfr(format_table, .id="year") %>%
  mutate_at(vars(year, day), as.numeric) %>%
  mutate_at(vars(deals:offers), map, parse_nested_deals) %>%
  mutate(category="Cheddar Block, 40lb")

cheese_price_details <- bind_rows(bar_df, blk_df) %>%
  select(category, everything())
