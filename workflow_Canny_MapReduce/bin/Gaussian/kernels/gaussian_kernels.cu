#ifdef __cplusplus
extern "C" {
#endif
#define L_SIZE 16

__constant__ float gaus[3][3] =  { {0, 1, 0},
                                {1, -3, 1},
                                {0, 1, 0} };

__global__ void gauss_kernel( int* data,
                               int* out,
                                       int cols,int rows)
{
int g_row = blockIdx.x * blockDim.x + threadIdx.x;
int g_col = blockIdx.y * blockDim.y + threadIdx.y;
int pos = g_col * cols + g_row;

int l_row = threadIdx.x + 1;
int l_col = threadIdx.y + 1;
    
int sum=0;
  
  __shared__ int l_data[L_SIZE+2][L_SIZE+2];

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

 

    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            sum += gaus[i][j] * l_data[i+l_row-1][j+l_col-1];


out[pos] = max(0,sum); ;

    return;
}

#ifdef __cplusplus
}
#endif
