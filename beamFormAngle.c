# include "math.h"
# include "omp.h"
# include "mex.h"

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{
    double fs, c, width, kerf, eleSpace, spaSpac;
    double alphaT, alphaR;
    double eleSpac, sapSpac;
    
    double * rawData;
    int m, n;
    double *tTot, * delayValueT, * delayValueR;
    double * dasData;
    double deltaZ, deltaX;
    
    double * steerLabel;
    
    int * delayData;

    int i, j, k;
    double pi = 3.1415926535897932384626;
    double z, x, xi, ttx, trx;
    double delay;

    int apeSize;
    int iIntep;
    
    int i1, j1, k1, apeSize1, iIntep1, delay1;
    double z1, x1, xi1, ttx1, trx1;    
    /////////////////////////
    fs = 40e6;
    c  = 1540.0;
    // Parameter of the L14-38 Xducer.
    width = 0.2798e-3;
    kerf  = 0.0250e-3;
    eleSpac = width + kerf;
    
    sapSpac = c/fs/2;
    //////////////////////////
    rawData    = mxGetPr(prhs[0]);
    m          = mxGetM(prhs[0]);
    n          = mxGetN(prhs[0]);
    
    // The delay between the transmission of the high-voltage pulse
    // and the start of the acquisition of the SonixDAQ
    tTot       = mxGetPr(prhs[1]);
    
    // Note that the unit of transmit delay determined in Texo
    // between the adjacent element is 12.5 ns (or 80 MHz sampling rate)
    // refer the note in {Apr. 22, 2014}
    // delayValueT = mxGetPr(prhs[2]);
    // alphaT = atan(12.5e-9 * *delayValueT * c/eleSpac);
    
    alphaT = *(mxGetPr(prhs[2]));
    
    
    /////////////////////////
    // Window functions
    
//     for (i = 0; i < 66; i ++)
//         printf("%f\n", win[i]);
    //////////////////////////////
    
    plhs[0] = mxCreateNumericMatrix(m, (509), mxDOUBLE_CLASS, 0);
    dasData = mxGetPr(plhs[0]);
    plhs[1] = mxCreateNumericMatrix(n, 1, mxINT32_CLASS, 0);
    delayData = mxGetPr(plhs[1]);
    
    // apeSize = 24;
    deltaZ = c/fs/2; //eleSpac / 4 / 20;
    // x = 0;
    

    #pragma omp parallel for shared(dasData, rawData, alphaR, alphaT, eleSpac, steerLabel, n, m, deltaZ, deltaX, pi) \
                             private(i, j, k, iIntep, z, x, xi, ttx, trx, delay, apeSize)
    //////
    for (i = 0; i < 509; i ++)      // x-direction
    {
        z = 1e-3;
        x = i * eleSpac/4;
        
        // iIntep = (int) (i/2);
        iIntep = (int)( x / eleSpac + 0.5);  // Position of the central element        
        
        for (j = 0; j < m; j ++)  // z-direction
        {                        
             ttx = z * cos(alphaT) + x * sin(alphaT);
             // Unit in [m]
             apeSize = (int) (z/1.4/0.3048*1e3);
             if (apeSize < 8)
                 apeSize = 8;
//              if (apeSize > 32)
//                  apeSize = 32;
            
             for (k = -apeSize; k < apeSize + 1; k ++)
             {
                 if ((k + iIntep) < 0 || (k + iIntep) >= n)
                     continue;
                
                 xi = (iIntep + k) * eleSpac;
                 // Unit in [m]
                 trx = sqrt( (x - xi) * (x - xi) + z * z);
                 // Unit in [m]
                 delay = (ttx + trx)/c * fs + *tTot;
                 // Uint in [s]
                
                 //mexPrintf("%d\n", delay);
                if (delay >= (m-1) || delay < 0)
                    continue;
     
                dasData[i * m + j] += (0.54 - 0.46 * cos(pi*(k + apeSize + 0.0)/apeSize)) \
                                * ( (delay - (int) (delay))                             \
                                    * (   rawData[(k + iIntep) * m + (int) (delay + 1.0) ]  \
                                        - rawData[(k + iIntep) * m + (int) (delay)       ]) \
                                       +  rawData[(k + iIntep) * m + (int) (delay) ] );
            }
            z += deltaZ;
        }
    }   
    
    return;
}
