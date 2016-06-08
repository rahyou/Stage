#if defined(cl_khr_fp64)  // Khronos extension available?
#pragma OPENCL EXTENSION cl_khr_fp64 : enable
#elif defined(cl_amd_fp64)  // AMD extension available?
#pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif

 
/*__constant float gaus[3][3] = { {0.0625, 0.125, 0.0625},
                                {0.1250, 0.250, 0.1250},
                                {0.0625, 0.125, 0.0625} };*/

__constant float gaus[3][3] = { {1, 1, 1},
                                {1, 1, 1},
                                {1, 1, 1} };

#define L_SIZE 16


// Gaussian Kernel
// data: image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out: image output data (8B1C)
__kernel void gauss_kernel(__global const int * data,
                           __global   int * out,
                                       int img_width,
                                       int img_height)
{
int pos = get_local_id (0) + (get_group_id(0) * get_local_size (0));
//int y = get_local_id (1) + (get_group_id(1) * get_local_size (1));	
const int size =  get_local_size (0);
__local int l_data[3][3];
int sum=0;
int globale_taille = 512*512 -1;
 
 

   // copy to local
    int pos00 = pos -img_height -1;
    
if(pos00 >= 0 && pos00 <= globale_taille)
       l_data[0][0] = data[pos00];
    else
       l_data[0][0] = 0;

    int pos01 = pos - 1;
    if(pos01 >= 0 && pos01 <= globale_taille)
      l_data[0][1] = data[pos01];
    else
       l_data[0][1] = 0;


int pos02 = pos + img_height -1;
if(pos02 >= 0 && pos02 <= globale_taille)
   l_data[0][2] = data[pos + img_height -1]; 
else
       l_data[0][2] = 0;


int pos10 = pos - img_height ;
if(pos10 >= 0 && pos10 <= globale_taille)
   l_data[1][0] = data[pos -img_height];
else
       l_data[1][0] = 0;


int pos11 = pos;
if(pos11 >= 0 && pos11 <= globale_taille)
 l_data[1][1] = data[pos ];
else
       l_data[1][1] = 0;

int pos12 = pos +img_height;
if(pos12 >= 0 && pos12 <= globale_taille)
l_data[1][2] = data[pos +img_height];
else
       l_data[1][2] = 0;

int pos20 = pos - img_height +1;
if(pos20 >= 0 && pos20 <= globale_taille)
   l_data[2][0] = data[pos - img_height +1];
else
       l_data[2][0] = 0;

int pos21 = pos + 1;
if(pos21 >= 0 && pos21 <= globale_taille)
 l_data[2][1] = data[pos + 1 ];
else
       l_data[2][1] = 0;

int pos22 = pos + img_height +1;
if(pos22 >= 0 && pos22 <= globale_taille)
l_data[2][2] = data[pos + img_height +1];
else
       l_data[2][2] = 0;

   // barrier(CLK_LOCAL_MEM_FENCE);


    for (int i = 0; i < 3; i++)
        for (int j = 0; j < 3; j++)
            sum += gaus[i][j] * l_data[i][j];



 out[pos] = sum;//min(255,max(0,sum));

    return;
}
