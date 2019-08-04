#' Cheese data
#'
#' Worldwide cheese catalogue from www.cheese.com as of 2018-07-22
#'
#' @source Worldnews 2018, Specialty cheese catalogue
#'  <https:://www.cheese.com>
#' @format Data frame with columns
#' \describe{
#' \item{name, title}{Name of the cheese variety.}
#' \item{description}{Long description of the cheese.}
#' \item{href}{Link to page on cheese.com homepage.}
#' \item{alternative_spelling}{Alternative name of the cheese.}
#' \item{aroma}{Cheese aroma.}
#' \item{cakcium_content}{Content of calcium in cheese.}
#' \item{colour}{Cheese colour}
#' \item{country_of_origin}{Cheese's country (countries) of origin}
#' \item{family}{Cheese family.}
#' \item{fat_content, fat_content_in_dry_matter_}{Fat content in the cheese.}
#' \item{flavour}{Cheese flavor.}
#' \item{made_from}{Kind of milk the cheese is made from.}
#' \item{producers}{Names of cheese producers.}
#' \item{region}{Region of the country producing cheese.}
#' \item{rind}{Cheese rind.}
#' \item{synonyms}{Altenative descriptions for the cheese.}
#' \item{texture}{Cheese texture}
#' \item{type}{Cheese type}
#' \item{vegetarian}{Whether or not the cheese is vegetarian.}
#' }
"cheese"

#'
#' Cheese price: Average monthly CME cheese block and barrel prices from www.cheesereporter.com for 2001-2019
#'
#' @source Cheesereporter.com 2019, CME Cheese Block & Barrel Prices
#'  <https:://www.cheesereporter.com>
#' @format Data frame with columns
#' \describe{
#' \item{category}{Either Cheddar Block (40lb) or Cheddar Barrel (500lb).}
#' \item{date}{Date for the month (BoM) for which data was collected.}
#' \item{price}{Price in US Dollars.}
#' }
"cheese_price"

#'
#' Cheese price details: CME cheese block and barrel trading details from www.cheesereporter.com for 2011-2018
#'
#' @source Cheesereporter.com 2019, CME Cheese Block & Barrel Trading Details
#'  <https:://www.cheesereporter.com>
#' @format Tibble with columns
#' \describe{
#' \item{category}{Either Cheddar Block (40lb) or Cheddar Barrel (500lb).}
#' \item{year, month, day}{Date when the trading event happened.}
#' \item{price}{Price in US Dollars.}
#' \item{volume}{Number of trades happening on that day.}
#' \item{deals}{List-column storing number of trades, price and bid/offer flag for transaction.}
#' \item{bids}{List-column storing number of unfilled bids, price and bid/offer flag.}
#' \item{offers}{List-column storing number of unfilled offers, price and bid/offer flag.}
#' }
"cheese_price_details"


#' @importFrom tibble tibble
NULL
