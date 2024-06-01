clc;clear all;
img = imread('../picture/ikun.jpg');
img = rgb2gray(img);
img = uint8(img);
imwrite(img,'../picture/ikun.bmp','bmp');
img = imresize(img , [1280,720]);
subplot(131);
imshow(img);
% generate_data(img);
fileid='../data/region_bin_ikun.dat';  
display_data(fileid);



% 将数据恢复成图像
function display_data(fileid)     
fid=fopen(fileid,'r');                     %打开数据文件
formatSpec = '%x';
sizea = [1280 720];
bmp=fscanf(fid,formatSpec,sizea);             %读取文件数据
fclose(fid);                                %关闭文件
bmp = uint8(bmp);
subplot(133);imshow(bmp);
end

function generate_data(ikun)
% 生成灰度图数据
bar = waitbar(0,'data generating >>>>');
fid = fopen('../data/shade_text2.dat','wt');
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