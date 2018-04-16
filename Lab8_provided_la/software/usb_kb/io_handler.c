//io_handler.c

#include "io_handler.h"
#include <stdio.h>

void IO_init(void)
{
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
	*otg_hpi_data = 0;
	// Reset OTG chip
	*otg_hpi_cs = 0;
	*otg_hpi_reset = 0;
	*otg_hpi_reset = 1;
	*otg_hpi_cs = 1;
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
//*************************************************************************////
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	// Write the address to access to HPI_ADDR
		*otg_hpi_address = Address;
		*otg_hpi_cs = 0;
		*otg_hpi_w = 0;
		// Write data to HPI_DATA in 16-bit little endian words
		*otg_hpi_data = Data;
		*otg_hpi_w = 1;
		*otg_hpi_cs = 1;
}

alt_u16 IO_read(alt_u8 Address)
{
	alt_u16 temp;
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	// Write the address to access to HPI_ADDR
		*otg_hpi_address = Address;
		*otg_hpi_cs = 0;
		*otg_hpi_r = 0;
		// Read from HPI_DATA
		temp = *otg_hpi_data;
		*otg_hpi_r = 1;
		*otg_hpi_cs = 1;
	//printf("%x\n",temp);
	return temp;
}
