// Non-maximum Supression Kernel
// data: image input data with each pixel taking up 1 byte (8Bit 1Channel)
// out: image output data (8B1C)
// theta: angle input data  
__kernel void non_max_supp_kernel(__global uchar *data,
                                  __global uchar *out,
                                 __global uchar *theta,
                                           size_t rows,
                                           size_t cols)
{
    // These variables are offset by one to avoid seg. fault errors
    // As such, this kernel ignores the outside ring of pixels
    size_t g_row = get_global_id(0);
    size_t g_col = get_global_id(1);
    size_t l_row = get_local_id(0) + 1;
    size_t l_col = get_local_id(1) + 1;
    
   
    
 



    uchar my_magnitude = data[pos];

    // The following variables are used to address the matrices more easily
    switch (theta[pos])
    {
        // A gradient angle of 0 degrees = an edge that is North/South
        // Check neighbors to the East and West
        case 0:
            // supress me if my neighbor has larger magnitude
            if (my_magnitude <= l_data[pos+1] || // east
                my_magnitude <= l_data[pos-1])   // west
            {
                out[pos] = 0;
            }
            // otherwise, copy my value to the output buffer
            else
            {
                out[pos] = my_magnitude;
            }
            break;
                
        // A gradient angle of 45 degrees = an edge that is NW/SE
        // Check neighbors to the NE and SW
        case 45:
            // supress me if my neighbor has larger magnitude
            if (my_magnitude <= l_data[l_row-1][l_col+1] || // north east
                my_magnitude <= l_data[l_row+1][l_col-1])   // south west
            {
                out[pos] = 0;
            }
            // otherwise, copy my value to the output buffer
            else
            {
                out[pos] = my_magnitude;
            }
            break;
                    
        // A gradient angle of 90 degrees = an edge that is E/W
        // Check neighbors to the North and South
        case 90:
            // supress me if my neighbor has larger magnitude
            if (my_magnitude <= l_data[l_row-1][l_col] || // north
                my_magnitude <= l_data[l_row+1][l_col])   // south
            {
                out[pos] = 0;
            }
            // otherwise, copy my value to the output buffer
            else
            {
                out[pos] = my_magnitude;
            }
            break;
                    
        // A gradient angle of 135 degrees = an edge that is NE/SW
        // Check neighbors to the NW and SE
        case 135:
            // supress me if my neighbor has larger magnitude
            if (my_magnitude <= l_data[l_row-1][l_col-1] || // north west
                my_magnitude <= l_data[l_row+1][l_col+1])   // south east
            {
                out[pos] = 0;
            }
            // otherwise, copy my value to the output buffer
            else
            {
                out[pos] = my_magnitude;
            }
            break;
                    
        default:
            out[pos] = my_magnitude;
            break;
    } 
}
