#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

void R_symphony_solve(int *n_cols, int *n_rows, int *start, int *index, 
                      double *value, double *col_lb, double *col_ub,
                      int* is_int, double *objective, double *obj2,
                      char **row_sense, double *row_rhs,
                      double *row_range, double *obj_final,
                      double *sol_final, int *solve_status,
		      int *verbosity, int *time_limit, int *node_limit,
		      double *gap_limit, int *first_feasible, int *write_lp,
		      int *write_mps);

static const R_CMethodDef CEntries[] = {
    {"R_symphony_solve", (DL_FUNC) &R_symphony_solve, 23},
    {NULL, NULL, 0}
};

void R_init_Rsymphony(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
