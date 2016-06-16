// Some of the available convolution kernels
__constant int sobx[3][3] = { {-1, 0, 1},
                              {-2, 0, 2},
                              {-1, 0, 1} };

__constant int soby[3][3] = { {-1,-2,-1},
                              { 0, 0, 0},
                              { 1, 2, 1} };

#define L_SIZE 16
// Sobel kernel. Apply sobx and soby separately, then find the sqrt of their
//               squares.
// data:  image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out:   image output data (8B1C)
// theta: angle output data  
__kernel void sobel_kernel(__global float *data,
                           __global float *out,
                             __global float *theta, 
                                   int cols,
                                    int rows)
{
    // collect sums separately. we're storing them into floats because that
    // is what hypot and atan2 will expect.
    const float PI = 3.14;
int g_row = get_local_id (1) + (get_group_id(1) * get_local_size (1));	
int g_col = get_local_id (0) + (get_group_id(0) * get_local_size (0));
size_t pos = g_col * rows + g_row;

    size_t l_row = get_local_id(0) + 1;
    size_t l_col = get_local_id(1) + 1;


  __local int l_data[18][18];

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
        else if (l_col == 16)
            l_data[0][17] = data[pos-cols+1];
    }
    // bottom most row
    else if (l_row == 16)
    {
        l_data[17][l_col] = data[pos+cols];
        // bottom left
        if (l_col == 1)
            l_data[17][0] = data[pos+cols-1];

        // bottom right
        else if (l_col == 16)
            l_data[17][17] = data[pos+cols+1];
    }

    // left
    if (l_col == 1)
        l_data[l_row][0] = data[pos-1];
    // right
    else if (l_col == 16)
        l_data[l_row][17] = data[pos+1];

    barrier(CLK_LOCAL_MEM_FENCE);

    float sumx = 0, sumy = 0, angle = 0, max = 0;
    // find x and y derivatives
    for (int i = 0; i < 3; i++)
    {
        for (int j = 0; j < 3; j++)
        {
		if ( max < l_data[i+l_row-1][j+l_col-1] )
			max = l_data[i+l_row-1][j+l_col-1];

            sumx += sobx[i][j] * l_data[i+l_row-1][j+l_col-1];
            sumy += soby[i][j] * l_data[i+l_row-1][j+l_col-1];
        }
    }


    // The output is now the square root of their squares, but they are
    // constrained to 0 <= value <= 255. Note that hypot is a built in function
    // defined as: hypot(x,y) = sqrt(x*x, y*y).
    
 	short Sum = ((abs((int)sumx )+abs((int)sumy)));
 int hyp = (int)hypot(sumx,sumy) ;

   // if (hyp > 0)
   // {
    //    out[pos]= hyp;
   // }
   // else
 if (hyp > max)
    {
        out[pos]= hyp;
    }
else  out[pos]  =  0  ;
    // Compute the direction angle theta in radians
    // atan2 has a range of (-PI, PI) degrees
    angle = atan2(sumy,sumx);

    // If the angle is negative, 
    // shift the range to (0, 2PI) by adding 2PI to the angle, 
    // then perform modulo operation of 2PI
    if (angle < 0)
    {
        angle = fmod((angle + 2*PI),(2*PI));
    }

    // Round the angle to one of four possibilities: 0, 45, 90, 135 degrees
    // then store it in the theta buffer at the proper position
theta[pos]=((int)(degrees(angle * (PI/8) + PI/8-0.0001) / 45) * 45) % 180;
}
    
 
/*    
   int pos = get_local_id (0) + (get_group_id(0) * get_local_size (0));

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


int pos02 = pos - img_height +1;;//+ img_height -1;
if(pos02 >= 0 && pos02 <= globale_taille)
   l_data[0][2] = data[pos + img_height -1]; 
else
       l_data[0][2] = 0;


int pos10 = pos-1; //- img_height ;
if(pos10 >= 0 && pos10 <= globale_taille)
   l_data[1][0] = data[pos -img_height];
else
       l_data[1][0] = 0;


int pos11 = pos;
if(pos11 >= 0 && pos11 <= globale_taille)
 l_data[1][1] = data[pos ];
else
       l_data[1][1] = 0;

int pos12 = pos +1; //+img_height;
if(pos12 >= 0 && pos12 <= globale_taille)
l_data[1][2] = data[pos +img_height];
else
       l_data[1][2] = 0;

int pos20 = pos+ img_height -1;// - img_height +1;
if(pos20 >= 0 && pos20 <= globale_taille)
   l_data[2][0] = data[pos - img_height +1];
else
       l_data[2][0] = 0;

int pos21 = pos + img_height;// + 1;
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
*/
   
