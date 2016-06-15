#if defined(cl_khr_fp64)  // Khronos extension available?
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#elif defined(cl_amd_fp64)  // AMD extension available?
#pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif

 
/*__constant float gaus[3][3] = { {0.0625, 0.125, 0.0625},
                                {0.1250, 0.250, 0.1250},
                                {0.0625, 0.125, 0.0625} };
*/
__constant float gaus[3][3] = { {0, 1, 0},
                                {1, -3, 1},
                                {0, 1, 0} };

#define L_SIZE 16

// Gaussian Kernel
// data: image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out: image output data (8B1C)
__kernel void gauss_kernel(__global const int * data,
                           __global   int * out,
                                       int cols,
                                       int rows)
{

int g_row = get_local_id (1) + (get_group_id(1) * get_local_size (1));	
int g_col = get_local_id (0) + (get_group_id(0) * get_local_size (0));
int pos = g_col * rows + g_row;

int sum=0;
int globale_taille = 512*512 -1;
 out[pos] = data [pos];

    size_t l_row = get_local_id(0) + 1;
    size_t l_col = get_local_id(1) + 1;
    
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


out[pos] = max(0,sum);

    return;
}
