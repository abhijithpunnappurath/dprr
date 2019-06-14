function out=si(a,b)
a=double(a);
b=double(b);
c=0;%0.0001;
asig=std(a(:));
bsig=std(b(:));
abcov=cov(a(:),b(:));
out=(2*abs(abcov(1,2))+c)/(asig^2+bsig^2+c);