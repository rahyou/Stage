#if defined(cl_khr_fp64)  // Khronos extension available?
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#elif defined(cl_amd_fp64)  // AMD extension available?

#pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif

__kernel void vec_add(__global const float * a,__global const float * b, __global float * c, int N)
{
    int nIndex = get_global_id(0);
    if (nIndex < N)
    {
      c[nIndex] = a[nIndex] + b[nIndex];
    }
}

