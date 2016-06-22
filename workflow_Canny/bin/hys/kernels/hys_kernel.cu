#ifdef __cplusplus
extern "C" {
#endif

__global__ void hys_kernel( int* data,
                               int* out,
                                       int rows,
                                       int cols)

{	float lowThresh = 60;
	float highThresh = 170;

	int g_row = threadIdx.y + (blockIdx.y * blockDim.y);
	int g_col = threadIdx.x + (blockIdx.x * blockDim.x);
int pos = g_col * cols + g_row;



   const int EDGE = 16777215;

   int magnitude = data[pos];
    
    if (magnitude >= highThresh)
        out[pos] = EDGE;
    else if (magnitude <= lowThresh)
        out[pos] =  EDGE;
    else
    {

       float med = (highThresh + lowThresh)/2;
        
        if (magnitude >= med)
            out[pos] = EDGE;
        else
             out[pos] = 0;
    }
}
#ifdef __cplusplus
}
#endif
