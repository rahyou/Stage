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
  int tid;
  int i;
  int res;
  tid = (get_local_id (0)) + (get_local_size (0)) * (get_group_id (0)) ;
  if (tid <= w * h){
    i = tid * 3 ;
    res = (int) (0.21f * (float) (v[i])  + 0.71f * (float) (v[i + 1])  + 0.07f * (float) (v[i + 2]) )  ;
    v[i] = res; ;
    v[i + 1] = res; ;
    v[i + 2] = res;
  }  
  
  
  
}