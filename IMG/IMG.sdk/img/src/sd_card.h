/*
 * sd_card.h
 *
 *  Created on: 2023年12月17日
 *      Author: dpt
 */

#ifndef SRC_SD_CARD_H_
#define SRC_SD_CARD_H_

//#define FILE_NAME "test.txt"                //定义文件名
#define PICTURE_NAME1 "ikun.bmp"                //定义图片文件名(和SD卡内的保持一致)
#define PICTURE_NAME2 "ikun.bmp"
#define PICTURE_NAME3 "ikun.bmp"

void init_sd_card();				        //加载SD设备
int sd_read_data(char *file_name,u32 src_addr,u32 byte_len);//SD卡读数据
int sd_write_data(char *file_name,u32 src_addr,u32 byte_len);//SD卡写数据

void load_sd_bmp(u8 *frame,	u8 cnt);//读取图片数据
int sd_mount();
int platform_init_fs();

#endif /* SRC_SD_CARD_H_ */
