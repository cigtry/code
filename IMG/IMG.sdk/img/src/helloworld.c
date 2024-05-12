#include "xil_printf.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "xil_io.h"
#include "xparameters.h"
#include "xil_cache.h"

#define H_STRIDE            1280
#define H_ACTIVE            1280
#define V_ACTIVE            720
#define VIDEO_LENGTH  	(H_STRIDE*V_ACTIVE)

#define VDMA_BASEADDR   XPAR_AXI_VDMA_0_BASEADDR
#define VIDEO_BASEADDR0 0x08000000
#define BUF_SIZE 		((H_STRIDE*V_ACTIVE)*3)




int VDMA_init( )
 {
//	u8 *mem_addr = VIDEO_BASEADDR0;
//	u8 R[3]={0xFF,0x00,0x00};
//	u8 G[3]={0x00,0xFF,0x00};
//	u8 B[3]={0x00,0x00,0xFF};
//	u8 W[3]={0xFF,0xFF,0xFF};
//	u8 Y[3]={0xFF,0xFF,0x00};
//	u8 GRAY[3]={0x80,0x80,0x80};
//	for (int row=0;row < V_ACTIVE;row ++)
//	{
//		for(int col=0;col<H_ACTIVE;col++)
//		{
//			if(col<210) memcpy(mem_addr,R,3);
//			else if(col<420) memcpy(mem_addr,G,3);
//			else if(col<630)  memcpy(mem_addr,B,3);
//			else if(col<840)  memcpy(mem_addr,W,3);
//			else if(col<1050)  memcpy(mem_addr,Y,3);
//			else memcpy(mem_addr,GRAY,3);
//			mem_addr+=3;
//		}
//	}
	//Xil_DCacheFlush();
	Xil_Out32((VDMA_BASEADDR + 0x000), 0x3);//0011
	Xil_Out32((VDMA_BASEADDR + 0x05c), VIDEO_BASEADDR0);
	Xil_Out32((VDMA_BASEADDR + 0x060), VIDEO_BASEADDR0);
	Xil_Out32((VDMA_BASEADDR + 0x064), VIDEO_BASEADDR0);
	Xil_Out32((VDMA_BASEADDR + 0x058), (H_STRIDE*3));
	Xil_Out32((VDMA_BASEADDR + 0x054), (H_ACTIVE*3));
	Xil_Out32((VDMA_BASEADDR + 0x050), V_ACTIVE);
	return 1;
}


int main()
{

			VDMA_init();

			//int j=0;
//			u8 r,g,b;
//			for (int row=0;row < V_ACTIVE;row ++)
//					{
//						for(int col=0;col<H_ACTIVE;col++)
//						{
//							b = gImage_picture[j+2];
//							g = gImage_picture[j+1];
//							r = gImage_picture[j];
//							Xil_Out32((VIDEO_BASEADDR0+j),((r<<16)|(g<<8)|(b<<0)));
//							j+=3;
//						}
//					}

			//Xil_DCacheFlush();


			return 0;
}