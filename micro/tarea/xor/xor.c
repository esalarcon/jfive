#include <stdio.h>
#include <stdlib.h>

unsigned int xor32(void)
{
	static unsigned int y=2463534242;
	y^=(y<<13); 
	y^=(y>>17);
	y^=(y<<5); 
	return y;
}


int main(int argc, char *argv[])
{
	int i;
	int n_vals=0;
	if(argc == 2)
	{
		n_vals = atoi(argv[1]); 
	}
	for(i=0;i<n_vals || n_vals==0;i++)
	{
		printf("0x%08X\n",xor32());
	}
	return EXIT_SUCCESS;
}
