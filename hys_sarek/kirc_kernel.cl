float spoc_fadd ( float a, float b );
float spoc_fminus ( float a, float b );
float spoc_fmul ( float a, float b );
float spoc_fdiv ( float a, float b );
int logical_and (int, int);
int spoc_powint (int, int);
int spoc_xor (int, int);
float spoc_fadd ( float a, float b ) { return (a + b);}
float spoc_fminus ( float a, float b ) { return (a - b);}
float spoc_fmul ( float a, float b ) { return (a * b);}
float spoc_fdiv ( float a, float b ) { return (a / b);}
int logical_and (int a, int b ) { return (a & b);}
int spoc_powint (int a, int b ) { return ((int) pow (((float) a), ((float) b)));}
int spoc_xor (int a, int b ) { return (a^b);}
/************* CUSTOM TYPES ******************/


/************* FUNCTION PROTOTYPES ******************/
/************* FUNCTION DEFINITIONS ******************/
__kernel void spoc_dummy ( __global int* v, int w, int h ) {
  int lowThresh;
  int highThresh;
  int med;
  int edge;
  int tid;
  int i;
  int magnitude;
  int r;
  int g;
  int b;
  lowThresh = 170 ;
  highThresh = 90 ;
  med = highThresh + lowThresh / 2 ;
  edge = 16777215 ;
  tid = (get_local_id (0)) + (get_local_size (0)) * (get_group_id (0)) ;
  if (tid <= w * h){
    i = tid * 3 ;
    magnitude = v[i] * 256 + v[i + 1] * 256 + v[i + 2] ;
    if (magnitude >= med){
      r = edge / 65536 ;
      g = edge / 256 % 256 ;
      b = edge % 256 ;
      v[i] = r; ;
      v[i + 1] = g; ;
      v[i + 2] = b;
    }
    else{
      v[i] = 0; ;
      v[i + 1] = 0; ;
      v[i + 2] = 0;
    }
    
  }  
  
  
  
  
  
  
  
  
  
  
}