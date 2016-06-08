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


    int sum = 0;
   // int g_row = get_global_id(0);
  //  int g_col = get_global_id(1);
    //int l_row = get_local_id(0) + 1;
   // int l_col = get_local_id(1) + 1;
    
    int pos = get_local_id(0) + 1; //g_row * cols + g_col;
    
    __local int l_data[L_SIZE+2][L_SIZE+2];

    // copy to local
    l_data[l_row][l_col] = data[pos];

    // top most row
    if (l_row == 1)
    {
        l_data[0][l_col] = data[pos-cols];
        // top left
        if (l_col == 1)
            l_data[0][0] = data[pos-cols-1];

        // top right
        else if (l_col == L_SIZE)
            l_data[0][L_SIZE+1] = data[pos-cols+1];
    }
    // bottom most row
    else if (l_row == L_SIZE)
    {
        l_data[L_SIZE+1][l_col] = data[pos+cols];
        // bottom left
        if (l_col == 1)
            l_data[L_SIZE+1][0] = data[pos+cols-1];

        // bottom right
        else if (l_col == L_SIZE)
            l_data[L_SIZE+1][L_SIZE+1] = data[pos+cols+1];
    }

    if (l_col == 1)
        l_data[l_row][0] = data[pos-1];
    else if (l_col == L_SIZE)
        l_data[l_row][L_SIZE+1] = data[pos+1];

    barrier(CLK_LOCAL_MEM_FENCE);

    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            sum += gaus[i][j] * l_data[i+l_row-1][j+l_col-1];

    out[pos] = min(255,max(0,sum)); 

