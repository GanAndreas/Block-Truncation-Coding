function [out]=EDbtc(in,bs)
%in–> input image, bs-block size(2,4,..)
in=im2double(in);
fc=[0 -99*16 7; 3 5 1]/16; 

[ri,ci]=size(in);
[rm,cm]=size(fc);
[r0,c0]=find(fc==-99);    % find origin of error filter
fc(r0,c0)=0;

rm=rm-1; cm=cm-1;
inpad=padarray(in,[0 1],'both');
inpad=padarray(inpad,[1],'post');
out=zeros(ri,ci); qn=out;

for i=r0:bs:ri+(r0-1)
for j=c0:bs:ci+(c0-1)
    i1=i-(r0-1);
    j1=j-(c0-1);
    block=in(i1:i1+bs-1,j1:j1+bs-1);
    mn=mean(block(:));
    a=max(block(:));
    b=min(block(:));
        
    for y=i:i+bs-1
    for x=j:j+bs-1
        y1=y-(r0-1);
        x1=x-(c0-1);

        if inpad(y,x)>=mn
            outpix=a;
        else
            outpix=b;
        end    
        out(y1,x1)=outpix;
        qerr=inpad(y,x)-outpix;
        qn(y1,x1)=qerr;
        qerr=qerr.*fc;
        bl_inpad=inpad(y1:y1+rm,x1:x1+cm);
        bl_inpad=bl_inpad+qerr;
        inpad(y1:y1+rm,x1:x1+cm)=bl_inpad;
    end     
    end

end
end

% in1=imgaussfilt(in,1.3);
% out1=imgaussfilt(out,1.3);
% 
% fprintf('\n');
% [peaksnr, snr] = psnr(in, out);
% fprintf('\n The Peak-SNR value is %0.4f. \n', peaksnr);
% [peaksnr, snr] = psnr(in1, out1);
% fprintf('\n The H-Peak-SNR value is %0.4f. \n', peaksnr);
% imshow(in),figure,imshow(out),figure,imshow(out1);

% imwrite(out,'lena_EDbtc_64.jpg');

in=im2uint8(in);
out=im2uint8(out);
hp=HPSNRnew(in,out,bs,1.3);
end


