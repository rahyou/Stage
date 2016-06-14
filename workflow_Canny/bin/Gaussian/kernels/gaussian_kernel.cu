#ifdef __cplusplus
extern "C" {
#endif
__constant float gaus[3][3] = { {0.0625, 0.125, 0.0625},
                                {0.1250, 0.250, 0.1250},
                                {0.0625, 0.125, 0.0625} };

#define L_SIZE 16

// Gaussian Kernel
// data: image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out: image output data (8B1C)
__global__ void gauss_kernel( int* data,
                               int* out,
                                       int rows,int cols)
{
int index = blockIdx.x * blockDim.x + threadIdx.x;

	if (index >= numberOfPixels){
		//printf("%d\n",index);
		return;
	}

	int mask[] = { 1, 2, 1, 2, 4, 2, 1, 2, 1 };
	int s = mask[0] + mask[1] + mask[2] + mask[3] + mask[4] + mask[5] + mask[6] + mask[7] + mask[8];

	if (index < width){ // dolny rzad pikseli
		if (index == 0){ //lewy dolny rog
			s = mask[4] + mask[1] + mask[2] + mask[5];
			B_new[index] = (int)((B[index] * mask[4] + B[index + width] * mask[1] + B[index + width + 1] * mask[2] + B[index + 1] * mask[5]) / s);
			G_new[index] = (int)((G[index] * mask[4] + G[index + width] * mask[1] + G[index + width + 1] * mask[2] + G[index + 1] * mask[5]) / s);
			R_new[index] = (int)((R[index] * mask[4] + R[index + width] * mask[1] + R[index + width + 1] * mask[2] + R[index + 1] * mask[5]) / s);
			return;
		}

		if (index == width - 1){//prawy dolny rog
			s = mask[4] + mask[0] + mask[1] + mask[3];
			B_new[index] = (B[index] * mask[4] + B[index + width - 1] * mask[0] + B[index + width] * mask[1] + B[index - 1] * mask[3]);
			G_new[index] = (G[index] * mask[4] + G[index + width - 1] * mask[0] + G[index + width] * mask[1] + G[index - 1] * mask[3]);
			R_new[index] = (R[index] * mask[4] + R[index + width - 1] * mask[0] + R[index + width] * mask[1] + R[index - 1] * mask[3]);
			return;
		}
		//reszta pikseli w dolnym rzedzie
		s = mask[4] + mask[1] + mask[2] + mask[5] + mask[0] + mask[3];
		B_new[index] = (int)((B[index] * mask[4] + B[index + width] * mask[1] + B[index + width + 1] * mask[2] + B[index + 1] * mask[5] + B[index + width - 1] * mask[0] + B[index - 1] * mask[3]) / s);
		R_new[index] = (int)((R[index] * mask[4] + R[index + width] * mask[1] + R[index + width + 1] * mask[2] + R[index + 1] * mask[5] + R[index + width - 1] * mask[0] + R[index - 1] * mask[3]) / s);
		G_new[index] = (int)((G[index] * mask[4] + G[index + width] * mask[1] + G[index + width + 1] * mask[2] + G[index + 1] * mask[5] + G[index + width - 1] * mask[0] + G[index - 1] * mask[3]) / s);

		return;
	}
	if (index >= numberOfPixels - width){ //gorny rzad pikseli

		if (index == numberOfPixels - width){ //lewy gorny rog
			s = mask[4] + mask[5] + mask[7] + mask[8];
			B_new[index] = (int)((B[index] * mask[4] + B[index + 1] * mask[5] + B[index - width] * mask[7] + B[index - width + 1] * mask[8]) / s);
			G_new[index] = (int)((G[index] * mask[4] + G[index + 1] * mask[5] + G[index - width] * mask[7] + G[index - width + 1] * mask[8]) / s);
			R_new[index] = (int)((R[index] * mask[4] + R[index + 1] * mask[5] + R[index - width] * mask[7] + R[index - width + 1] * mask[8]) / s);
			return;
		}

		if (index == numberOfPixels - 1){ //prawy gorny rog
			s = mask[4] + mask[3] + mask[6] + mask[7];
			B_new[index] = (int)((B[index] * mask[4] + B[index - 1] * mask[3] + B[index - width - 1] * mask[6] + B[index - width] * mask[7]) / s);
			G_new[index] = (int)((G[index] * mask[4] + G[index - 1] * mask[3] + G[index - width - 1] * mask[6] + G[index - width] * mask[7]) / s);
			R_new[index] = (int)((R[index] * mask[4] + R[index - 1] * mask[3] + R[index - width - 1] * mask[6] + R[index - width] * mask[7]) / s);
			return;
		}

		s = mask[4] + mask[3] + mask[5] + mask[6] + mask[7] + mask[8];
		B_new[index] = (int)((B[index] * mask[4] + B[index - 1] * mask[3] + B[index - width - 1] * mask[6] + B[index - width] * mask[7] + B[index + 1] * mask[5] + B[index - width] * mask[8]) / s);
		R_new[index] = (int)((R[index] * mask[4] + R[index - 1] * mask[3] + R[index - width - 1] * mask[6] + R[index - width] * mask[7] + R[index + 1] * mask[5] + R[index - width] * mask[8]) / s);
		G_new[index] = (int)((G[index] * mask[4] + G[index - 1] * mask[3] + G[index - width - 1] * mask[6] + G[index - width] * mask[7] + G[index + 1] * mask[5] + G[index - width] * mask[8]) / s);
		return;
	}
	if (index % width == 0){ //lewa sciana
		s = mask[4] + mask[1] + mask[2] + mask[5] + mask[8] + mask[7];
		B_new[index] = (int)((B[index] * mask[4] + B[index + width] * mask[1] + B[index + width + 1] * mask[2] + B[index + 1] * mask[5] + B[index - width + 1] * mask[8] + B[index - width]) / s);
		G_new[index] = (int)((G[index] * mask[4] + G[index + width] * mask[1] + G[index + width + 1] * mask[2] + G[index + 1] * mask[5] + G[index - width + 1] * mask[8] + G[index - width]) / s);
		R_new[index] = (int)((R[index] * mask[4] + R[index + width] * mask[1] + R[index + width + 1] * mask[2] + R[index + 1] * mask[5] + R[index - width + 1] * mask[8] + R[index - width]) / s);
		return;
	}
#ifdef __cplusplus
}
#endif
