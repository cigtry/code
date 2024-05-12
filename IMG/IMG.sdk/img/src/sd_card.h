/*
 * sd_card.h
 *
 *  Created on: 2023��12��17��
 *      Author: dpt
 */

#ifndef SRC_SD_CARD_H_
#define SRC_SD_CARD_H_

//#define FILE_NAME "test.txt"                //�����ļ���
#define PICTURE_NAME1 "ikun.bmp"                //����ͼƬ�ļ���(��SD���ڵı���һ��)
#define PICTURE_NAME2 "ikun.bmp"
#define PICTURE_NAME3 "ikun.bmp"

void init_sd_card();				        //����SD�豸
int sd_read_data(char *file_name,u32 src_addr,u32 byte_len);//SD��������
int sd_write_data(char *file_name,u32 src_addr,u32 byte_len);//SD��д����

void load_sd_bmp(u8 *frame,	u8 cnt);//��ȡͼƬ����
int sd_mount();
int platform_init_fs();

#endif /* SRC_SD_CARD_H_ */
