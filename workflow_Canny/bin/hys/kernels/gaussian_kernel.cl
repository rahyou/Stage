#if defined(cl_khr_fp64)  // Khronos extension available?
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#elif defined(cl_amd_fp64)  // AMD extension available?
#pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif

 
/*__constant float gaus[3][3] = { {0.0625, 0.125, 0.0625},
                                {0.1250, 0.250, 0.1250},
                                {0.0625, 0.125, 0.0625} };*/

__constant float gaus[3][3] = { {1, 1, 1},
                                {1, 1, 1},
                                {1, 1, 1} };

#define L_SIZE 16


// Gaussian Kernel
// data: image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out: image output data (8B1C)
__kernel void gauss_kernel(__global const int * data,
                           __global   int * out,
                                       int img_width,
                                       int img_height)
{	float lowThresh = 10;
	float highThresh = 70;


int pos = 
get_local_id (0) + (get_group_id(0) * get_local_size (0));
   const uchar EDGE = 255;

 /*   uchar magnitude = data[pos];
    
    if (magnitude >= highThresh)
        out[pos] = EDGE;
    else if (magnitude <= lowThresh)
        out[pos] =  0;
    else
    {

       float med = (highThresh + lowThresh)/2;
        
        if (magnitude >= med)
            out[pos] = EDGE;
        else
             out[pos] =  out[pos] = 0;
    }
*/

}
