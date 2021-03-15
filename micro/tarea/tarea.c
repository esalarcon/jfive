unsigned int xor32(unsigned int y)
{
	y^=(y<<13); 
	y^=(y>>17);
	y^=(y<<5); 
	return y;
}

int main(void)
{
	int i=0;
	unsigned int y=2463534242;

	volatile int *puerto_entrada = (volatile int*)0x20000;
	volatile int *puerto_salida  = (volatile int*)0x10000;
	while(1)
	{
		if(((*puerto_entrada)&0x0F) == 0x0F)
		{
			y = xor32(y);
			*puerto_salida = y;
			for(i=0;i<300000;i++);
		}
	}
	return 0;
}
