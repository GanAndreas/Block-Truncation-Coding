function [H]=btc(in,bs)
%in–> input image, bs-block size(2,4,..)
in=im2double(in);
[s1 s2]=size(in);
n=bs*bs;
for i=1:bs:s1
for j=1:bs:s2
    bl=in(i:i+(bs-1),j:j+(bs-1));
    mn=mean(bl(:)) ; %Computing Mean
    sd=std(double(bl(:)),1); %Standard Deviation
    c=bl>mn;
    q=nnz(c);
    a=mn-(sd*sqrt((q)/(n-q)));
    b=mn+(sd*sqrt((n-q)/(q)));
    if (isinf(a)==1) || (isnan(a)==1) 
        a=0;
    end
    if (isinf(b)==1) || (isnan(b)==1) 
        b=0;
    end
    out=((c).*b+((~c)).*a);
    H(i:i+(bs-1),j:j+(bs-1))=out;
end
end

% in1=imgaussfilt(in,1.3);
% H1=imgaussfilt(H,1.3);

% [peaksnr, snr] = psnr(in1, H1);
% fprintf('\n The H-Peak-SNR value is %0.4f. \n', peaksnr);
% 
% [peaksnr, snr] = psnr(in, H);
% fprintf('\n The Peak-SNR value is %0.4f. \n', peaksnr);
% imshow(in),figure,imshow(H);


% imwrite(H,'lena_btc_64.jpg');

in=im2uint8(in);
H=im2uint8(H);
hp=HPSNRnew(in,H,bs,1.3);
end