# fuego - 

Rather than running R functions via a script, fue::go constructs a function call and runs it directly, to be used via R -e.

This was inspired by Fire in python.

## Details

Shell arguments that begin with "–" set named arguments, everything else is matched positionally using standard R matching rules.

## Examples

    # the following all call scale(mtcars, center=TRUE, scale=FALSE)
    R -e "fue::go(scale)" --args  --no-scale --center --x=mtcars
    R -e "fue::go(scale)" --args  mtcars --scale=FALSE --center
    R -e "fue::go(scale)" --args  --no-scale mtcars TRUE


    # Bash quoting can be tricky at times. This is a shell issue, not an R issue.
    R -e "fue::go(paste)" --args  '"Here I am"' '"Rock you like a Hurricane"'


    # included is a shell script "fuego" that does all the boilerplate:
    fuego scale --no-scale mtcars TRUE

## See also

Other packages that may serve this purpose better include littler and docopt
