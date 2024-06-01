/*
 * sd_card.h
 *
 *  Created on: 2024年4月28日
 *      Author: maccura
 */

#ifndef SRC_SD_CARD_H_
#define SRC_SD_CARD_H_

#include "xil_printf.h"
#include "ff.h"
#include "xdevcfg.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "xparameters.h"


typedef struct
{
	uint16_t bfType;        //文件类型，BMP格式为字符串BM
	uint32_t bfSize;		//图片大小，单位为KB
	uint16_t bfReserved1;	//保留位
	uint16_t bfReserved2;	//保留位
	uint32_t bfOffBits;  	//从文件头到实际图像数据之间的字节偏移量
} BMP_FileHeaderTypeDef;

typedef struct
{
	uint32_t bitSize;		 //BMP_InfoHeaderTypeDef结构体所需要的字节数
	uint32_t biWidth;		 //图片宽度，像素位单位
	int32_t  biHeight;		 //图片高度，像素为单位。正为倒立，负为正向。
	uint16_t biPlanes;		 //颜色平面数，总为1
	uint16_t biBitCount;	 //比特数/像素。其值为：1、4、8、16、24或32
	uint32_t biCompression;  //数据压缩类型
	uint32_t biSizeImage;	 //图像大小
	uint32_t biXPelsPerMeter;//水平分辨率
	uint32_t biYPelsPerMeter;//垂直分辨率
	uint32_t biClrUsed;		 //颜色索引数
	uint32_t biClrImportant; //重要颜色索引数

}BMP_InfoHeaderTypeDef;

typedef struct
{
	 BMP_FileHeaderTypeDef *fileHeader ;
	 BMP_InfoHeaderTypeDef *infoHeader ;

}BMP_HeaderTypeDef;


int platform_init_fs();
int sd_mount();
int sd_write_data(char *file_name , u32 src_addr , u32 byte_len);
int sd_read_data(char *file_name , u32 src_addr , u32 byte_len);
int  sdcard_init();
int  SD_init();
int SD_read(char *FileName, char *DestinationAddress, unsigned int ByteLength);
int SD_write(char *FileName, char *SourceAddress, unsigned int ByteLength);
void load_sd_bmp(u8 *frame);
void BMP_Picture(uint8_t *dir , uint8_t  * buf ,uint32_t len);
void BMP_ReadHeader(uint8_t *header, BMP_HeaderTypeDef *bmp);
#endif /* SRC_SD_CARD_H_ */
