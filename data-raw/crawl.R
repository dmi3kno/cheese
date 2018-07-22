
cheese_get_labels <- function(i, page, tag){
# tag should be #id_i for letters and #id_page for pages
  cheese_get_html(i=i, page=page) %>%
    rvest::html_nodes(paste0("#id_",tag," label input")) %>%
    rvest::html_attr("value")
}


cheese_parse_gallery <-  function(i, page, verbose=FALSE){
   if(verbose) message("Parsing page ", page, " for ", i)
  #Urls to pages are under ""
  page <- cheese_get_html(i=i, page=page)
  cheese_rel_href <-  page %>%
    rvest::html_nodes("h3 a") %>%
    rvest::html_attr("href")
  cheese_name <- page %>%
    rvest::html_nodes("h3 a") %>%
    rvest::html_text()
  url <- getOption("cheese.url")
  base_url <- regmatches(url,regexpr("^.+?[^\\/:](?=[?\\/]|$)",url, perl = TRUE))
  res <- tibble::tibble(
    url=paste(base_url,cheese_rel_href,sep=""),
    name=cheese_name
  )

res
}


cheese_parse_page <- function(url, name, verbose=FALSE){
  if(verbose) message("Parsing page for ", name)
  page <- cheese_get_html(url=url)

  cheese_title <- page %>%
    rvest::html_node("#main-body h1") %>%
    rvest::html_text()

  cheese_summary <- page %>%
    rvest::html_nodes(".summary-points p") %>%
    rvest::html_text() %>%
    base::list() %>%
    lapply(gsub, pattern="Made from ", replacement="Made from: ")

  cheese_description <- page %>%
    rvest::html_nodes(".description p") %>%
    rvest::html_text() %>%
    base::paste0(collapse = "\n")

  res <- tibble::tibble(cheese_name=name,
                        cheese_title=cheese_title,
                        cheese_summary=cheese_summary,
                        cheese_description=cheese_description,
                        cheese_href=url
    )

  res
}
