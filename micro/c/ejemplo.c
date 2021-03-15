int main(void)
{
	volatile int *puerto_entrada = (volatile int*)0x20000;
	volatile int *puerto_salida  = (volatile int*)0x10000;
	while(1)
	{
		*puerto_salida = ~(*puerto_entrada);
	}
	return 0;
}
