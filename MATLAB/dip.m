clc;clear all;
ikun = imread('../picture/ikun.jpg');
ikun = rgb2gray(ikun);
ikun = uint8(ikun);
% 添加椒盐噪声
% ikun = imnoise(ikun,'salt & pepper',0.01);
imwrite(ikun,'../picture/ikun.bmp','bmp');
ikun = imresize(ikun , [1280,720]);
subplot(121);
imshow(ikun);
% ikun_avg_fialter = imfilter(ikun,fspecial('average',3),'replicate');%均值滤波
% ikun_avg_fialter = imfilter(ikun,fspecial('gaussian',[5,5],3),'replicate');%高斯滤波
% subplot(132);
% imshow(ikun_avg_fialter);

%generate_data(ikun);
% fileid='../data/ikun_avg_fialter.dat';  
%  fileid='../data/med_filter.dat';  
%  fileid='../data/average_filter.dat';  
fileid='../data/gauss_filter.dat';  
% fileid='../data/bilateral_filter.dat';  
% fileid='../data/soble_detec.dat';  
display_data(fileid);



% 将数据恢复成图像
function display_data(fileid)     
fid=fopen(fileid,'r');                     %打开数据文件
formatSpec = '%x';
sizea = [1280 720];
bmp=fscanf(fid,formatSpec,sizea);             %读取文件数据
fclose(fid);                                %关闭文件
bmp = uint8(bmp);
subplot(122);imshow(bmp);
end

function generate_data(ikun)
% 生成灰度图数据
bar = waitbar(0,'data generating >>>>');
fid = fopen('../data/ikun_avg_fialter.dat','wt');
h = size(ikun , 1);
w = size(ikun , 2);
for row = 1:w
    str_data_tmp = [];
    for col = 1:h
        data = lower(dec2hex(ikun(col,row),2));
        str_data_tmp = [str_data_tmp,data,' '];
    end
    str_data_tmp = [str_data_tmp,10];
    fprintf(fid,'%s',str_data_tmp);
    waitbar(row/h);
end
fclose(fid);
close(bar);
end


