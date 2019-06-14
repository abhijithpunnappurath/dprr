function corr_value=xcorr_normalized_color(f1c,f2c)
for i=1:3
f1=f1c(:,:,i);
f2=f2c(:,:,i);
f1=double(f1);
f2=double(f2);
f1=f1./sqrt(sum(sum(f1.^2)));
f2=f2./sqrt(sum(sum(f2.^2)));
% C1=xcorr2(f1,f2);
 C1=myxcorr2(f1,f2);
Nor1=sqrt(sum(sum(f1.^2)))*sqrt(sum(sum(f2.^2)));
corr_value(i) = max(C1(:))/Nor1;
end
corr_value=mean(corr_value);
end

function mycorr=myxcorr2(f1,f2)
b=11;
[r,c]=size(f1);
f2b=zeros(size(f1,1)+b,size(f1,2)+b);
f2b(1:r,1:c)=f2;
mycorr=zeros(b,b);
for m=1:b
    for n=1:b
    mycorr(m,n)=sum(sum(f1.*f2b(1+m-1:r+m-1,1+n-1:c+n-1))); 
    end
end
end