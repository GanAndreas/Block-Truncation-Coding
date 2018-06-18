%Function to compute HPSNR

function hp=HPSNRnew(in,in1,fs,d)
%fs==> Block Size
%d==> standard deviation

[s1 s2]=size(in);
 in=double(in);
 in1=double(in1);

 b1=mod(s1,fs);
 b2=mod(s2,fs);
 bs=fs-1;
 in=padarray(in,[b1 b2]);
 in1=padarray(in1,[b1 b2]);

%Gaussian Filter
gaulen=(fs-1)/2; 
for k=-gaulen:gaulen
    for l=-gaulen:gaulen
        c=(k*k + l*l)/(2*d*d);
        GF(k+gaulen+1,l+gaulen+1)=exp(-c)/(2*3.14*d*d);
    end
end
SErr=0;
for i=1:fs:s1-1
    for j=1:fs:s2-1            
        ima=in(i:i+bs,j:j+bs);
        imr=in1(i:i+bs,j:j+bs) ;      
        Err=ima-imr;
        Err=conv2(Err,GF,'same').^2;
        SErr=SErr+sum(sum(Err));
    end
end
hp=10*log10(((s1)*(s2)*255.^2)/SErr);
fprintf('\n The H-Peak-SNR value is %0.4f. \n', hp);
end

        
        
        