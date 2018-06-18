function [H]=ODbtc(in,bs)
%in–> input image, bs-block size(2,4,..)
in=im2double(in);
[s1 s2]=size(in);


%Ordered Dithering - Halftoning
od=[1 17 5 21 2 18 6 22;
  25 9 29 13 26 10 30 14;
  7 23 3 19 8 24 4 20;
  31 15 27 11 32 16 28 12;
  2 18 6 22 1 17 5 21;
  26 10 30 14 25 9 29 13;
  8 24 4 20 7 23 3 19;
  32 16 28 12 31 15 27 11]/32;

for a=1:8
for b=1:8
    od_temp=(od(a,b)-min(od(:)))/(max(od(:))-min(od(:)));
    od_new(a,b)=od_temp;
end
end

od_new=repmat(od_new,round(s1/8),round(s2/8));

%BTC
for i=1:bs:s1
for j=1:bs:s2
bl=in(i:i+(bs-1),j:j+(bs-1));

a=max(bl(:));
b=min(bl(:));

k=(a-b);

for m=i:1:i+bs-1
for n=j:1:j+bs-1
    DA = k*od_new(m,n);
    th = DA + b;
    c=in(m,n)>th;
    out=((c).*a+((~c)).*b);
    H(m,n)=out;
end
end

end
end

% in1=imgaussfilt(in,1.3);
% H1=imgaussfilt(H,1.3);

% [peaksnr, snr] = psnr(in, H);
% fprintf('\n The Peak-SNR value is %0.4f. \n', peaksnr);
% [peaksnr, snr] = psnr(in1, H1);
% fprintf('\n The H-Peak-SNR value is %0.4f. \n', peaksnr);
% imshow(in),figure,imshow(H);

% imwrite(H,'lena_ODbtc_64.jpg');

in=im2uint8(in);
H=im2uint8(H);
hp=HPSNRnew(in,H,bs,1.3);
end