// Hysteresis Threshold Kernel
// data: image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out: image output data (8B1C)

__constant float gaus[3][3] = { {0.0625, 0.125, 0.0625},
                                {0.1250, 0.250, 0.1250},
                                {0.0625, 0.125, 0.0625} };
__kernel void hyst_kernel(__global uchar *data,
                           __global uchar *out,
                                    int img_height,
                                    int cols)
{
	// Establish our high and low thresholds as floats
	float lowThresh = 10;
	float highThresh = 70;


int pos = get_local_id (0) + (get_group_id(0) * get_local_size (0));
   const uchar EDGE = 255;

    uchar magnitude = data[pos];
    
    if (magnitude >= highThresh)
        out[pos] = EDGE;
    else if (magnitude <= lowThresh)
        out[pos] =  0;
    else
    {

       float med = (highThresh + lowThresh)/2;
        
        if (magnitude >= med)
            out[pos] = EDGE;
        else
             out[pos] =  out[pos] = 0;
    }
}
