function [H]=bit_interleave(in,bs)
%in–> input image, bs-block size(2,4,..)
in=rgb2gray(in);
in=im2double(in);
[s1 s2]=size(in);

%Ordered Dithering - Halftoning
od=[0 48 12 60 3 51 15 63;
    32 16 44 28 35 19 47 31;
    8 56 4 52 11 59 7 55;
    40 24 36 20 43 27 39 23;
    2 50 14 62 1 49 13 61;
    34 18 46 30 33 17 45 29;
    10 58 6 54 9 57 5 53;
    42 26 38 22 41 25 37 21];
[o1 o2]=size(od);

out=zeros(512,512*o1*o2);

for ii=0:1:max(od(:))
    thres=ii/64;
    p=(ii*512)+1;
    temp=in>thres;
    out(1:512,p:p+511)=temp;
    H(1)=out;
end
imshow(out);    
end
