function [H]=ambtc1(in,bs)
%in–> input image; bs–> blocksize

in=rgb2gray(in);
in=im2double(in);
[s1 s2]=size(in);
n=bs*bs;
for i=1:bs:s1
for j=1:bs:s2
bl=in(i:i+(bs-1),j:j+(bs-1));
mn=mean(mean(bl)) ; %Computing Mean
fm=mean(mean(abs(bl-mn))) ; %Abs moment
g=(n*fm)/2;
c=bl>mn;
q=nnz(c);
if(q==n)
b=mn;
a=0;
else
b=mn+(g/q);
a=mn-(g/(n-q));
end
out=(c.*b+(~c).*a);
H(i:i+(bs-1),j:j+(bs-1))=out;
end
end
imshow(H);
end