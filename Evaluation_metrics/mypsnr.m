function val = mypsnr(a,b)
a=double(a);
b=double(b);
err=a(:)-b(:);
err=sqrt(sum(err.*err)./numel(err));
val=20*log10(255/err);