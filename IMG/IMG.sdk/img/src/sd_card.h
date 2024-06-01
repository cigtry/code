/*
 * sd_card.h
 *
 *  Created on: 2024��4��28��
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
	uint16_t bfType;        //�ļ����ͣ�BMP��ʽΪ�ַ���BM
	uint32_t bfSize;		//ͼƬ��С����λΪKB
	uint16_t bfReserved1;	//����λ
	uint16_t bfReserved2;	//����λ
	uint32_t bfOffBits;  	//���ļ�ͷ��ʵ��ͼ������֮����ֽ�ƫ����
} BMP_FileHeaderTypeDef;

typedef struct
{
	uint32_t bitSize;		 //BMP_InfoHeaderTypeDef�ṹ������Ҫ���ֽ���
	uint32_t biWidth;		 //ͼƬ��ȣ�����λ��λ
	int32_t  biHeight;		 //ͼƬ�߶ȣ�����Ϊ��λ����Ϊ��������Ϊ����
	uint16_t biPlanes;		 //��ɫƽ��������Ϊ1
	uint16_t biBitCount;	 //������/���ء���ֵΪ��1��4��8��16��24��32
	uint32_t biCompression;  //����ѹ������
	uint32_t biSizeImage;	 //ͼ���С
	uint32_t biXPelsPerMeter;//ˮƽ�ֱ���
	uint32_t biYPelsPerMeter;//��ֱ�ֱ���
	uint32_t biClrUsed;		 //��ɫ������
	uint32_t biClrImportant; //��Ҫ��ɫ������

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
