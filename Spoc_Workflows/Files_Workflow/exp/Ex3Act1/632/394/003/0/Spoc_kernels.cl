
#elif defined(cl_amd_fp64)  // AMD extension available?
#pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif


#if __OPENCL_VERSION__ &amp;lt;= CL_VERSION_1_1
    #pragma OPENCL EXTENSION cl_khr_fp64 : enable
#endif


__kernel void vec_a(__global const float * a,__global const float * b, __global float * c, int N)
{
    int nIndex = get_global_id(0);
    if (nIndex < N)
    {
      c[nIndex] = a[nIndex] + b[nIndex];
    }
}



