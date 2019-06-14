function out=lmse(f1,f2,w)
f1=double(f1);
f2=double(f2);
[row,col,~]=size(f1);
if(mod(w,2)==0)
    w=w+1;
end
den=0;
num=0;
for i=1:(w+1)/2:row
    for j=1:(w+1)/2:col
        t1=f1(i:min(i+w,row),j:min(j+w,col),:);
        t2=f2(i:min(i+w,row),j:min(j+w,col),:);
        t3=t1(:)-t2(:);
        den=den+sum(t1(:).*t1(:)/numel(t1));
        num=num+sum(t3(:).*t3(:)/numel(t3));
    end
end
out=1-(num/den);