function [H]=btc1(in,bs)
%in–> input image, bs-block size(2,4,..)
in=rgb2gray(in);
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
out=(c).*b+(~c).*a;
H(i:i+(bs-1),j:j+(bs-1))=out;
end
end
imshow(H),figure,imshow(in);
end