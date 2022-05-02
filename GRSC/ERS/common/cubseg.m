function [labels,bmapOnImg] = cubseg(data,nC)


[M,N,B]=size(data);
Y_scale=scaleForSVM(reshape(data,M*N,B));
% Y_scale = reshape(indian_pines,M*N,B);
Y=reshape(Y_scale,M,N,B);
p = 1;
[Y_pca] = pca(Y_scale, p);
% Y_pca = mean(Y_scale,2);
img = im2uint8(mat2gray(reshape(Y_pca', M, N, p)));

% Ratio=Edge_ratio3(img);

% sigma=0.05;
% K = round(Ratio * 2000);
grey_img = im2uint8(mat2gray(Y(:,:,30)));
labels = mex_ers(double(img),nC);
[height,width] = size(grey_img);
[bmap] = seg2bmap(labels,width,height);
bmapOnImg = img;
idx = find(bmap>0);
timg = grey_img;
timg(idx) = 255;
bmapOnImg(:,:,2) = timg;
bmapOnImg(:,:,1) = grey_img;
bmapOnImg(:,:,3) = grey_img;

% figure;
% imshow(bmapOnImg,[],'InitialMagnification','fit');
% imwrite(grey_img,'bmapOnImg.bmp')
%     PicPath = ['./' ,'Indian.jpg'];
%     print('-djpeg','-r1200', PicPath);
% title('superpixel boundary map');

end

% function [Ratio]=Edge_ratio3(img)
%  [m,n] = size(img);
% %  img =  rgb2gray(img);
%  BW = edge(img,'log');
% %  figure,imshow(BW)
%  ind = find(BW~=0);
%  Len = length(ind);
%  Ratio = Len/(m*n);
% end