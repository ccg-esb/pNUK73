//  ODfit model used by package deSolve in pNUK73
//
//  Created by RPM on 28/5/14.
//
// Implements deterministic batch model with one bacterial type and a single-limiting resource to be used with R 
// To compile from R: system("R CMD SHLIB ODfit.c")
// To load from R (in Unix): dyn.load("ODfit.so")
// To call from R use deSolve package and see details in help on using compiled code.

#include <R.h> 

static double parms[3];
#define rho parms[0]
#define m parms[1]
#define K parms[2]

/* initializer */
void initmod(void (* odeparms)(int * , double *))
{
    int N=3;
    odeparms(&N, parms);
}

/* derivatives and one output variable 
y[0] is R (Resource)
y[1] is B (Bacterial density)
*/
void derivs (int *neq, double *t, double *y, double *ydot, double *yout, int *ip)
{
    if(ip[0]<1) error("nout should be at least 1");
    ydot[0] = -m*y[0]/(K+y[0])*y[1];
    ydot[1] = rho*m*y[0]/(K+y[0])*y[1];
    yout[0]=y[1];
}

/* Jacobian matrix */
void jac(int *neq, double *t, double *y, int *ml, int *mu, double *pd, int *nrowpd, double *yout, int *ip)
{
    pd[0]=-(K*m*y[1])/((K+y[0])*(K+y[0]));
    pd[1]=-m*y[0]/(K+y[0]);
    pd[(*nrowpd)]=(rho*K*m*y[1])/(K+y[0])*(K+y[0]);
    pd[(*nrowpd)+1]=rho*m*y[0]/(K+y[0]);
    
}


