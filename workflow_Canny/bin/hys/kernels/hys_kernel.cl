#if defined(cl_khr_fp64)  // Khronos extension available?
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#elif defined(cl_amd_fp64)  // AMD extension available?
#pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif


#define L_SIZE 16


// Gaussian Kernel
// data: image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out: image output data (8B1C)
__kernel void hys_kernel(__global const int * data,
                           __global   int * out,
                                       int cols ,
                                       int rows)
{	float lowThresh = 60;
	float highThresh = 170;

int g_row = get_local_id (1) + (get_group_id(1) * get_local_size (1));	
int g_col = get_local_id (0) + (get_group_id(0) * get_local_size (0));
int pos = g_col * rows + g_row;

//int pos = get_local_id (0) + (get_group_id(0) * get_local_size (0));
   const int EDGE = 13421772;

    uchar magnitude = data[pos];
    
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



}
