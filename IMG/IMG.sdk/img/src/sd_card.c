
#include "xil_printf.h"
#include "ff.h"
#include "sd_card.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "xil_io.h"
#include "xparameters.h"
#include "xil_types.h"
#include "xil_cache.h"
#include "ff.h"
#include "xdevcfg.h"
//文件系统变量
static FATFS fatfs;
//挂在函数返回不同值的含义（翻译版）
static const char * FR_Table[]=
{
    "FR_OK：成功",                                      /* (0) Succeeded */
    "FR_DISK_ERR：底层硬件错误",                      /* (1) A hard error occurred in the low level disk I/O layer */
    "FR_INT_ERR：断言失败",                              /* (2) Assertion failed */
    "FR_NOT_READY：物理驱动没有工作",                  /* (3) The physical drive cannot work */
    "FR_NO_FILE：文件不存在",                          /* (4) Could not find the file */
    "FR_NO_PATH：路径不存在",                          /* (5) Could not find the path */
    "FR_INVALID_NAME：无效文件名",                      /* (6) The path name format is invalid */
    "FR_DENIED：由于禁止访问或者目录已满访问被拒绝",  /* (7) Access denied due to prohibited access or directory full */
    "FR_EXIST：由于访问被禁止访问被拒绝",              /* (8) Access denied due to prohibited access */
    "FR_INVALID_OBJECT：文件或者目录对象无效",          /* (9) The file/directory object is invalid */
    "FR_WRITE_PROTECTED：物理驱动被写保护",              /* (10) The physical drive is write protected */
    "FR_INVALID_DRIVE：逻辑驱动号无效",                  /* (11) The logical drive number is invalid */
    "FR_NOT_ENABLED：卷中无工作区",                      /* (12) The volume has no work area */
    "FR_NO_FILESYSTEM：没有有效的FAT卷",              /* (13) There is no valid FAT volume */
    "FR_MKFS_ABORTED：由于参数错误f_mkfs()被终止",             /* (14) The f_mkfs() aborted due to any parameter error */
    "FR_TIMEOUT：在规定的时间内无法获得访问卷的许可",         /* (15) Could not get a grant to access the volume within defined period */
    "FR_LOCKED：由于文件共享策略操作被拒绝",                 /* (16) The operation is rejected according to the file sharing policy */
    "FR_NOT_ENOUGH_CORE：无法分配长文件名工作区",             /* (17) LFN working buffer could not be allocated */
    "FR_TOO_MANY_OPEN_FILES：当前打开的文件数大于_FS_SHARE", /* (18) Number of open files > _FS_SHARE */
    "FR_INVALID_PARAMETER：参数无效"                         /* (19) Given parameter is invalid */
};
//初始化文件系统
int platform_init_fs()
{
	FRESULT status;
	TCHAR *Path = "0:/";
	BYTE work[FF_MAX_SS];
	//注册一个工作区
	//在使用任何其他文件函数之前，必须使用f_mount函数位每个使用卷注册一个工作区
	status = f_mount(&fatfs,Path,1);//挂载SD卡
	if(status != FR_OK){
		xil_printf("Volume is not FAT formated;formating FAT\r\n");
		status = f_mkfs(Path , FM_FAT32 , 0 , work ,sizeof work);
		if(status != FR_OK){
			xil_printf("Unable to format FATfs\r\n");
			return -1;
		}
	}
	status = f_mount(&fatfs , Path , 1);
	if(status != FR_OK){
		xil_printf("Unable to format FATfs\r\n");
		return -1;
	}
	return 0;
}
//挂载 SD(TF)卡
int sd_mount()
 {
 FRESULT status;
 //初始化文件系统（挂载 SD 卡，如果挂载不成功，则格式化 SD 卡）
 status = platform_init_fs();
 if(status){
	 xil_printf("ERROR: %d!\n",status /*FR_Table[status]*/);
	 return XST_FAILURE;
 	 }
 return XST_SUCCESS;
 }

 //SD 卡写数据
 int sd_write_data(char *file_name,u32 src_addr,u32 byte_len)
 {
 FIL fil; //文件对象
 UINT bw; //f_write 函数返回已写入的字节数

 //打开一个文件,如果不存在，则创建一个文件
  f_open(&fil,file_name,FA_CREATE_ALWAYS | FA_WRITE);
  //移动打开的文件对象的文件读/写指针 0:指向文件开头
  f_lseek(&fil, 0);
  //向文件中写入数据
  f_write(&fil,(void*) src_addr,byte_len,&bw);
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


//从SD卡中读取BMP图片
void load_sd_bmp(u8 *frame,	u8 cnt)
{
	static 	FATFS fatfs;
	FIL 	fil;
	UINT 	*bmp_width,*bmp_height,*bmp_size;
	u8 		bmp_head[54];
	UINT 	br;
	u8      *frame_col;
	int 	i;

	//挂载文件系统
	f_mount(&fatfs,"",1);

	//打开文件
	if(cnt == 0)
		f_open(&fil,PICTURE_NAME1,FA_READ);
	else if(cnt == 1)
		f_open(&fil,PICTURE_NAME2,FA_READ);
	else if(cnt == 2)
		f_open(&fil,PICTURE_NAME3,FA_READ);

	//移动文件读写指针到文件开头
	f_lseek(&fil,0);

	//读取BMP文件头
	f_read(&fil,bmp_head,54,&br);
	xil_printf("picture head: \n\r");
	for(i=0;i<54;i++)
		xil_printf(" %x",bmp_head[i]);

	//打印BMP图片分辨率和大小
	bmp_width  = (UINT *)(bmp_head + 0x12);//1920*3*
	bmp_height = (UINT *)(bmp_head + 0x16);//1080
	bmp_size   = (UINT *)(bmp_head + 0x22);
	xil_printf("\n width = %d, height = %d, size = %d bytes \n\r",*bmp_width,*bmp_height,*bmp_size);

    //这种写入内存的方法才是对的
	for(int i = 0;i<*bmp_height;i++)
	{
		frame_col = frame + (1080 - i - 1)*1920*4;//最后一行的第一个列开始显示
		for(int j = 0; j<*bmp_width; j++)
		{
			f_read(&fil,frame_col,3,&br);
			*(frame_col+3) = 0x00;//对应我的AXI总线fifo读取数据的方式
			frame_col = frame_col + 4;
		}
	}
	//关闭文件
	f_close(&fil);

//	Xil_DCacheFlush();     //刷新Cache，数据更新至DDR3中（如果主函数没有关闭cache，这里就需要刷新到DDR中）
	xil_printf("show bmp\n\r");
}
