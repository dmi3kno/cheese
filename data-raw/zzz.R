#.onLoad <- function(libname, pkgname) {
  op <- options()
  op.cheese <- list(
    cheese.url="https://cheese.com/alphabetical/"
  )
  toset <- !(names(op.cheese) %in% names(op))
  if(any(toset)) options(op.cheese[toset])

#  invisible()
#}
