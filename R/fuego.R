#' Run R functions from the CLI
#'
#' Rather than running R functions via a script, \code{fue::go} constructs a
#' function call and runs it directly, to be used via \code{R -e}.
#'
#' Shell arguments that begin with "--" can specify names for arguments, everything
#' else is matched positionally using standard R matching rules.
#'
#'
#' @examples
#' \dontrun{
#'   # the following all call scale(mtcars, center=TRUE, scale=FALSE)
#'   R -e "fue::go(scale)" --args  --no-scale --center --x=mtcars
#'   R -e "fue::go(scale)" --args  mtcars --scale=FALSE --center
#'   R -e "fue::go(scale)" --args  --no-scale mtcars TRUE
#' }
#'
#' \dontrun{
#'   # Bash quoting can be tricky at times. This is a shell issue, not an R issue.
#'   R -e "fue::go(paste)" --args  '"Here I am"' '"Rock you like a Hurricane"'
#' }
#'
#' \dontrun{
#'  # included is a shell script "fuego" that does all the boilerplate:
#'  fuego scale --no-scale mtcars TRUE
#' }
#'
#'
#' @name fue
#' @docType package
NULL



#' @export
go <- function(FUN, args=commandArgs(TRUE)) {
  FUN <- match.fun(FUN)

  m <- regexec('--(no-)?(\\w*)=?(.*$)',args)
  parsed <- regmatches(args, m)

  # print(parsed)

  w <- lengths(parsed) > 0

  names(args)[w]  <- lapply(parsed[w], `[[`, 3)
  names(args)[!w] <- ""
  args[w] <- lapply(parsed[w], function(x) if(x[[4]] == "") x[[2]]=="" else x[[4]])

  # dput(args)

  args <- lapply(args, parse, file="", n=NULL)
  args <- lapply(args, eval, envir=.GlobalEnv)
  # dput(args)

  do.call(FUN, args, TRUE, .GlobalEnv)
}

.onAttach <- function(libname, pkgname){
  if(interactive()) stop("DO NOT ATTACH FUE::GO")
}
