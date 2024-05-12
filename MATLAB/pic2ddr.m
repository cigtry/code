clc;
clear all;
Image=imread('../picture/ikun.jpg');
 
R=Image(:,:,1);
G=Image(:,:,2);
B=Image(:,:,3);
[row, col] = size(R);
 
fid = fopen('ai.bin','wb');
 
for i=1:row
    for j=1:col
      fwrite(fid,B(i,j));
      fwrite(fid,G(i,j));
      fwrite(fid,R(i,j));
    end
end
fclose(fid);

 