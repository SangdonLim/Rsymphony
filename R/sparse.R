## Simple functions for converting "matrix" type objects into the
## sparse "column major order" (CSC, modulo offsets) format used by
## SYMPHONY.

## matind: vector of the row indices corresponding to each entry of
##   value 
## values: vector of the values of nonzero entries of the constraint
##   matrix in column order.

make_csc_matrix <-
function(x)
    UseMethod("make_csc_matrix")

make_csc_matrix.matrix <-
function(x)
{
    if(!is.matrix(x))
        stop("Argument 'x' must be a matrix.")
   
    ind <- which(x != 0, arr.ind = TRUE, useNames = FALSE)
    if(!length(ind)) {
        ## As of 2016-08-29, the above gives integer(0) instead of a
        ## matrix in case x has zero rows or cols, because x != 0 drops
        ## dimensions ...
        ind <- matrix(ind, 0L, 2L)
    }
    
    list(matbeg = c(0L, cumsum(tabulate(ind[, 2L], ncol(x)))),
         matind = ind[, 1] - 1L,
         values = x[ind])
}

make_csc_matrix.simple_triplet_matrix <-
function(x)
{
    if(!inherits(x, "simple_triplet_matrix"))
        stop("Argument 'x' must be of class 'simple_triplet_matrix'.")

    ## The matrix method assumes that indices for non-zero entries are
    ## in row-major order, but the simple_triplet_matrix() constructor
    ## currently does not canonicalize accordingly ...
    ind <- order(x$j, x$i)
    list(matbeg = c(0L, cumsum(tabulate(x$j[ind], x$ncol))),
         matind = x$i[ind] - 1L,
         values = x$v[ind])
}

make_csc_matrix.dgCMatrix <- 
function(x) 
{
    list(matbeg = x@p, matind = x@i, values = x@x)
}

make_csc_matrix.matrix.csc <- 
function(x) 
{
    list(matbeg = x@ia - 1L, matind = x@ja - 1L, values = x@ra)
}

make_csc_matrix.dgTMatrix <-
function(x)
{
    ind <- order(x@j, x@i)
    list(matbeg = c(0L, cumsum(tabulate(x@j[ind] + 1L, x@Dim[2L]))),
         matind = x@i[ind],
         values = x@x[ind])
}

make_csc_matrix.matrix.coo <-
function(x)
{
    ind <- order(x@ja, x@ia)
    list(matbeg = c(0L, cumsum(tabulate(x@ja[ind], x@dimension[2L]))),
         matind = x@ia[ind] - 1L,
         values = x@ra[ind])
}

make_csc_matrix.dgRMatrix <-
function(x) {
    x <- Matrix::t(x)
    list(matbeg = x@p, matind = x@j, values = x@x)
}

make_csc_matrix.matrix.csr <-
function(x)
{
    x <- SparseM::t(x)
    list(matbeg = x@ia - 1L, matind = x@ja - 1L, values = x@ra)
}
