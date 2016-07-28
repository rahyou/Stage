#if defined(cl_khr_fp64)  // Khronos extension available?
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#elif defined(cl_amd_fp64)  // AMD extension available?
#pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif


// data: image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out: image output data (8B1C)
__kernel void hys_kernel(__global const int * data,
                           __global   int * out,
                                       int cols,
                                       int rows)
{	

float lowThresh = 170 ;
	float highThresh =255;
	float med = (highThresh + lowThresh)/2;
int g_row = get_local_id (1) + (get_group_id(1) * get_local_size (1));	
int g_col = get_local_id (0) + (get_group_id(0) * get_local_size (0));
int pos = g_col * cols + g_row;

   const int EDGE = 16777215;


   int magnitude = data[pos];
    
    if (magnitude >= highThresh)
        out[pos] = EDGE;
   else if (magnitude <= lowThresh)
       out[pos] =  0;
    else
    {
        
        if (magnitude >= med)
            out[pos] = EDGE;
        else
             out[pos] = 0;
    }

    
}



