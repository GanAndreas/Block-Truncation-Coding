function [H]=btc_rev(in,bs)

[s1 s2]=size(in);
n=bs*bs;
for i=1:bs:s1
for j=1:bs:s2
    bl=in(i:i+(bs-1),j:j+(bs-1));
    a=0.6353;
    b=0.6392;
    out=((bl).*b+((~bl)).*a);
    H(i:i+(bs-1),j:j+(bs-1))=out;
end
end
imshow(H);
end