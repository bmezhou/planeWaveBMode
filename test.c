# include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    double a;
    int b;
    a = 0.49;
    
    
    
    b = (int) (a + 1.0);
    
    printf("%d\n", b);
    
    b = (int) (a);
    printf("%d\n", b);
    
    b = (int) (a + 0.5);
    printf("%d\n", b);
    
    return;
}