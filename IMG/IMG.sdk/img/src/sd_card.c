/*
 * sd_card.c
 *
 *  Created on: 2024年4月28日
 *      Author: maccura
 */
#include "sd_card.h"
#include "xil_printf.h"
#include "ff.h"
#include "xdevcfg.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "xparameters.h"
#define FILE_NAME "ZYNQ.txt"
//#define BMP_NAME "desktop.bmp"
#define BMP_NAME "ikun.bmp"

const char src_str[30] = "www.kunkun.com";
static FATFS fatfs;



int platform_init_fs()
{
	FRESULT status;
	TCHAR *Path = "0:/";
	BYTE work[FF_MAX_SS];

	status = f_mount(&fatfs , Path ,1);
	if(status != FR_OK){
		xil_printf("Volume is not FAT formated;formating FAT\r\n");
		status = f_mkfs(Path,FM_FAT32,0,work,sizeof work);
		if(status != FR_OK){
			xil_printf("Unable to format FATfs %d\r\n",status);
			return -1;
		}
		status = f_mount(&fatfs , Path , 0);
			if(status != FR_OK){
				xil_printf("Unable to mount FATfs\r\n");
				return -1;
			}
	}
	return 0;
}

int sd_mount()
{
	FRESULT status;
	status = platform_init_fs();
	if(status)
	{
		xil_printf("ERROR :f_mount returned %d\r\n", status);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

//SD 卡写数据
 int sd_write_data(char *file_name,u32 src_addr,u32 byte_len)
 {
 FIL fil; //文件对象
 UINT bw; //f_write 函数返回已写入的字节数
 int status;
 u32 bw_reg;

 //打开一个文件,如果不存在，则创建一个文件原子哥在线教学： www.yuanzige.com 论坛:www.openedv.com


 status = f_open(&fil,file_name,FA_CREATE_ALWAYS | FA_WRITE);
 if(status){
	 xil_printf("f_open error :%d \n", status);
 }
 //移动打开的文件对象的文件读/写指针 0:指向文件开头
 f_lseek(&fil, 0);
 //向文件中写入数据
 bw_reg =  f_write(&fil,(void*) src_addr,byte_len,&bw);
 xil_printf("bw_reg = %d \t src_addr = %s \t &src_addr = %d\n",bw_reg,src_addr,&src_addr);
 //关闭文件
 f_close(&fil);
 return 0;
 }

 //SD 卡读数据
 int sd_read_data(char *file_name,u32 src_addr,u32 byte_len)
 {
 FIL fil; //文件对象
 UINT br; //f_read 函数返回已读出的字节数

 //打开一个只读的文件
 f_open(&fil,file_name,FA_READ);
 //移动打开的文件对象的文件读/写指针 0:指向文件开头
 f_lseek(&fil,0);
 //从 SD 卡中读出数据
 f_read(&fil,(void*)src_addr,byte_len,&br);
 //关闭文件
 f_close(&fil);
 return 0;
}

int sdcard_init()
 {

	 int status,len;
	 			char dest_str[30]="";
	 			status = sd_mount();
	 			if(status != XST_SUCCESS){
	 				xil_printf("Fail to open SD card!\n");
	 				return 0;
	 			}
	 			else
	 				xil_printf("Success to open sd card!\n");

	 			len = strlen(src_str);
	 			xil_printf("len =%d\n",len);
	 			sd_write_data(FILE_NAME,(u32)src_str,len);
	 			sd_read_data(FILE_NAME,(u32)dest_str,len);

	 			if(strcmp(src_str,dest_str)==0)
	 				xil_printf("equal\n");
	 			else
	 				xil_printf("not equal\n");
 }

//从SD卡中读取BMP图片
void load_sd_bmp(u8 *frame)
{
	static 	FATFS fatfs;
	FIL 	fil;
	u8		bmp_head[54];
	UINT 	*bmp_width,*bmp_height,*bmp_size;
	UINT 	br;
	int 	i;

	//挂载文件系统
	f_mount(&fatfs,"0:/",1);
	//打开文件
	f_open(&fil,BMP_NAME,FA_READ);
	//移动文件读写指针到文件开头FILE_SYSTEM_INTERFACE_SD
	f_lseek(&fil,0);
	//读取BMP文件头
	f_read(&fil,bmp_head,54,&br);
	xil_printf("%s head: \r\n",BMP_NAME);
	for(i=0;i<54;i++)
		xil_printf(" %x\n",bmp_head[i]);
	xil_printf("%s end \r\n", BMP_NAME);
	//打印BMP图片分辨率和大小
	bmp_width  = (UINT *)(bmp_head + 0x12);
	bmp_height = (UINT *)(bmp_head + 0x16);
	bmp_size   = (UINT *)(bmp_head + 0x22);
	xil_printf("width = %d, height = %d, size = %d bytes \r\n",
			*bmp_width,*bmp_height,*bmp_size);
	//读出图片，写入DDR
	for(i=*bmp_height-1;i>=0;i--){
		f_read(&fil,frame+i*(*bmp_width)*3,(*bmp_width)*3,&br);
	}

	//关闭文件
	f_close(&fil);

	Xil_DCacheFlush();     //刷新Cache，数据更新至DDR3中
	xil_printf("show bmp\n\r");

}


void BMP_ReadHeader(uint8_t *header, BMP_HeaderTypeDef *bmp)
{

	bmp->fileHeader->bfType = ((*header) << 8) | (*(header + 1));
	header += 2;

	bmp->fileHeader->bfSize = ((*(header + 3)) << 24) | ((*(header + 2)) << 16) |
	                         ((*(header + 1)) << 8) | (*header);
	header += 8;

	bmp->fileHeader->bfOffBits = ((*(header + 3)) << 24) | ((*(header + 2)) << 16) |
	                            ((*(header + 1)) << 8) | (*header);
	header += 4;

	bmp->infoHeader->bitSize = ((*(header + 3)) << 24) | ((*(header + 2)) << 16) |
	                          ((*(header + 1)) << 8) | (*header);
	xil_printf("bmp->infoHeader->bitSize = %d  \n",
			bmp->infoHeader->bitSize );
	header += 4;

	bmp->infoHeader->biWidth = ((*(header + 3)) << 24) | ((*(header + 2)) << 16) |
	                          ((*(header + 1)) << 8) | (*header);
	header += 4;

	bmp->infoHeader->biHeight = ((*(header + 3)) << 24) | ((*(header + 2)) << 16) |
	                           ((*(header + 1)) << 8) | (*header);
	header += 6;

	bmp->infoHeader->biBitCount = ((*(header + 1)) << 8) | (*header);

	header += 2;

	bmp->infoHeader->biCompression = ((*(header + 3)) << 24) | ((*(header + 2)) << 16) |
	                                ((*(header + 1)) << 8) | (*header);
	header += 4;

	bmp->infoHeader->biSizeImage = ((*(header + 3)) << 24) | ((*(header + 2)) << 16) |
	                              ((*(header + 1)) << 8) | (*header);
	header += 4;

	bmp->infoHeader->biXPelsPerMeter = ((*(header + 3)) << 24) | ((*(header + 2)) << 16) |
	                                  ((*(header + 1)) << 8) | (*header);
	header += 4;

	bmp->infoHeader->biYPelsPerMeter = ((*(header + 3)) << 24) | ((*(header + 2)) << 16) |
	                                  ((*(header + 1)) << 8) | (*header);
}

void BMP_Picture(uint8_t *dir , uint8_t  * buf ,uint32_t len)
{
		FRESULT res;
		FIL fsrc;
		UINT  br;
		UINT  a;

		uint8_t buffer[1024];

		BMP_HeaderTypeDef bmpHeader;

		/* 打开要读取的文件 */
		res = f_open(&fsrc, BMP_NAME, FA_READ);

		if(res == FR_OK)   //打开成功
	    {
			/* 读取BMP文件的文件信息 */
	        res = f_read(&fsrc, buffer, sizeof(buffer), &br);

			/* 将数组里面的数据放入到结构数组中，并排序好 */
			BMP_ReadHeader(buffer, &bmpHeader);

			a = bmpHeader.fileHeader->bfOffBits;    //去掉文件信息才开始是像素数据

			res=f_lseek(&fsrc, a);
			if(res)
			{
				return 0;
			}
			res = f_read(&fsrc, buf, len, &br);
	    }
    f_close(&fsrc);  //不论是打开，还是新建文件，一定记得关闭
}



