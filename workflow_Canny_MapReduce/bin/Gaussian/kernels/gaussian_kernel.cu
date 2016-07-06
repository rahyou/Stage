#ifdef __cplusplus
extern "C" {
#endif

__constant float gaus[3][3] = { {0, 1, 0},
                                {1, -3, 1},
                                {0, 1, 0} };
#define L_SIZE 16

// Gaussian Kernel
// data: image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out: image output data (8B1C)
__global__ void gauss_kernel( int* B,
                               int* out,
                                       int rows,
                                       int width)
{
int index = blockIdx.x * blockDim.x + threadIdx.x;

	if (index >= numberOfPixels){
		//printf("%d\n",index);
		return;
	}

	int mask[] = { 1, 2, 1, 2, 4, 2, 1, 2, 1 };
	int s = mask[0] + mask[1] + mask[2] + mask[3] + mask[4] + mask[5] + mask[6] + mask[7] + mask[8];

	if (index < width){ 
		if (index == 0){
			s = mask[4] + mask[1] + mask[2] + mask[5];
			out[index] = (int)((B[index] * mask[4] + B[index + width] * mask[1] + B[index + width + 1] * mask[2] + B[index + 1] * mask[5]) / s);
			
			return;
		}

		if (index == width - 1){
			s = mask[4] + mask[0] + mask[1] + mask[3];
			out[index] = (B[index] * mask[4] + B[index + width - 1] * mask[0] + B[index + width] * mask[1] + B[index - 1] * mask[3]);
		
			return;
		}
	
		s = mask[4] + mask[1] + mask[2] + mask[5] + mask[0] + mask[3];
		out[index] = (int)((B[index] * mask[4] + B[index + width] * mask[1] + B[index + width + 1] * mask[2] + B[index + 1] * mask[5] + B[index + width - 1] * mask[0] + B[index - 1] * mask[3]) / s);
		
		return;
	}
	if (index >= numberOfPixels - width){ 

		if (index == numberOfPixels - width){ 
			s = mask[4] + mask[5] + mask[7] + mask[8];
			out[index] = (int)((B[index] * mask[4] + B[index + 1] * mask[5] + B[index - width] * mask[7] + B[index - width + 1] * mask[8]) / s);
		
			return;
		}

		if (index == numberOfPixels - 1){ 
			s = mask[4] + mask[3] + mask[6] + mask[7];
			out[index] = (int)((B[index] * mask[4] + B[index - 1] * mask[3] + B[index - width - 1] * mask[6] + B[index - width] * mask[7]) / s);
			
			return;
		}

		s = mask[4] + mask[3] + mask[5] + mask[6] + mask[7] + mask[8];
		out[index] = (int)((B[index] * mask[4] + B[index - 1] * mask[3] + B[index - width - 1] * mask[6] + B[index - width] * mask[7] + B[index + 1] * mask[5] + B[index - width] * mask[8]) / s);
			return;
	}
	if (index % width == 0){ 
		s = mask[4] + mask[1] + mask[2] + mask[5] + mask[8] + mask[7];
		out[index] = (int)((B[index] * mask[4] + B[index + width] * mask[1] + B[index + width + 1] * mask[2] + B[index + 1] * mask[5] + B[index - width + 1] * mask[8] + B[index - width]) / s);
		
		return;
	}
#ifdef __cplusplus
}
#endif
