function [H]=DDbtc1(in,met,bs)
%in–> input image, bs-block size(2,4,..)
in=im2double(in);
[s1 s2]=size(in);
inpad=padarray(in,[1,1],'both');
% inpad_hist=0;

if(met==1)
    
              CM = [47 31 51 24 27 45 5 21;
                    37 63 53 11 22 4 1 33;
                    61 0 57 16 26 29 46 8;
                    20 14 9 62 18 41 38 6;
                    17 13 25 15 55 48 52 58;
                    3 7 2 32 30 34 56 60;
                    28 40 36 39 49 43 35 10;
                    54 23 50 12 42 59 44 19;];  %Messe-Vaidhya
                    kr=8;nn=63;
elseif(met==2)

               CM=  [34 48 40 32 29 15 23 31;    
                     42 58 56 53 21 5 7 10;
                     50 62 61 45 13 1 2 18;
                     38 46 54 37 25 17 9 26;
                     28 14 22 30 35 49 41 33;
                     20 4 6 11 43 59 57 52;
                     12 0 3 19 51 63 60 44;
                     24 16 8 27 39 47 55 36;]; %Knuth
                     kr=8;nn=63;
else

   CM= [207 0 13 17 28 55 18 102 81 97 74 144 149 169 170 172;
        3 6 23 36 56 50 65 87 145 130 137 158 182 184 195 221;
        7 14 24 37 67 69 86 5 106 152 150 165 183 192 224 1;
        15 26 43 53 51 101 115 131 139 136 166 119 208 223 226 4;
        22 39 52 71 84 103 164 135 157 173 113 190 222 225 227 16;
        40 85 72 83 104 117 167 133 168 180 200 219 231 228 12 21;
        47 120 54 105 123 132 146 176 179 202 220 230 245 2 20 41;
        76 73 127 109 138 134 178 181 206 196 229 244 246 19 42 49;
        80 99 112 147 142 171 177 203 218 232 243 248 247 33 48 68;
        108 107 140 143 185 163 204 217 233 242 249 255 44 45 70 79;
        110 141 88 75 175 205 214 234 241 250 254 38 46 77 116 100;
        111 148 160 174 201 215 235 240 251 252 253 61 62 93 94 125;
        151 159 189 199 197 216 236 239 25 31 60 82 92 95 124 114;
        156 188 191 209 213 237 238 29 32 59 64 91 118 78 128 155;
        187 194 198 212 9 10 30 35 58 63 90 96 122 129 154 161;
        193 210 211 8 11 27 34 57 66 89 98 121 126 153 162 186];
        kr=16;nn=255;

end

CM=repmat(CM,round(bs/kr),round(bs/kr));

%Diffusion Matrix

   DM=[1 2 1;
       2 0 2;
       1 2 1;]/12;
                
%    CM1=zeros(s1+2,s2+2)-1;
%    CM1(2:s1+1,2:s1+1)=CM;
%    CM=CM1;
   CM=padarray(CM,[1 1],-1,'both');
   H=zeros(s1,s2);     
              
for i=1:bs:s1
for j=1:bs:s2
    block=in(i:i+bs-1,j:j+bs-1);
    mn=mean(block(:));
    a=max(block(:));
    b=min(block(:)); 
%     i1=1; j1=1;
    for ii=0:1:nn
        [p1,p2]=(find(CM==ii));
        y=1;
        x=1;
        while y<=size(p1,1)
        while x<=size(p2,1)
            inpix=inpad(i-1+p1(y),j-1+p2(x));
            if inpix>=mn
                out=a;
            else
                out=b;
            end
            H(i-1+p1(y),j-1+p2(x)) = out;
            qerr=inpix-out;
            cl=CM(p1(y)-1:p1(y)+1,p2(x)-1:p2(x)+1);
            k=cl>ii;
            DM1=(DM.*k);
            DM1=DM/sum(DM1(:));
            err=DM1*qerr;
            
            inpad(p1(y)-1:p1(y)+1,p2(x)-1:p2(x)+1)= inpad(p1(y)-1:p1(y)+1,p2(x)-1:p2(x)+1)+err;
            
            y=y+1;
            x=x+1;
        end
        end
    end

end
end
  
H=H(2:(s1+1),2:(s2+1));

% in1=imgaussfilt(in,1.3);
% H1=imgaussfilt(H,1.3);
% 
% fprintf('\n');
% [peaksnr, snr] = psnr(in1, H1);
% fprintf('\n The H-Peak-SNR-1 value is %0.4f. \n', peaksnr);
% [peaksnr, snr] = psnr(in, H);
% fprintf('\n The Peak-SNR value is %0.4f. \n', peaksnr);
% imshow(in),figure,imshow(H),figure,imshow(H1);

% imwrite(H,'lena_DDbtc_64.jpg');

in=im2uint8(in);
H=im2uint8(H);
hp=HPSNRnew(in,H,bs,1.3);
end
