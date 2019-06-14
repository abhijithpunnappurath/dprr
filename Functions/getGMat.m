function [Gx,Gy,Gxx,Gxy,Gyy]=getGMat(w,h)
imgSize=w*h;

dS=[1,-1];
filtSizeS=1;

indsGx1=zeros(imgSize*2,1);
indsGx2=zeros(imgSize*2,1);
valsGx=zeros(imgSize*2,1);
indsGy1=zeros(imgSize*2,1);
indsGy2=zeros(imgSize*2,1);
valsGy=zeros(imgSize*2,1);

indy=0; indx=0;
for disp=0:filtSizeS,
    for x=1:w-1,	
       for y=1:h,
          indx=indx+1;
          indsGx1(indx)= sub2ind([h w],y,x);
          indsGx2(indx)= sub2ind([h w],y,x+disp);
          valsGx(indx)=dS(disp+1);
       end
    end
    for x=1:w,	
       for y=1:h-1,
           indy=indy+1;
           indsGy1(indy)= sub2ind([h w],y,x);
           indsGy2(indy)= sub2ind([h w],y+disp,x);
           valsGy(indy)=dS(disp+1);
       end;
    end;
end;

indsGx1=indsGx1(1:indx);
indsGx2=indsGx2(1:indx);
valsGx=valsGx(1:indx);
indsGy1=indsGy1(1:indy);
indsGy2=indsGy2(1:indy);
valsGy=valsGy(1:indy);



Gx=sparse(indsGx1,indsGx2,valsGx,imgSize,imgSize);
Gy=sparse(indsGy1,indsGy2,valsGy,imgSize,imgSize);

if (nargout>2)
   Gxx=Gx'*Gx;
   Gxy=Gx*Gy;
   Gyy=Gy'*Gy;
   nzGxx=sum(Gxx~=0,2);
   nzGyy=sum(Gyy~=0,2);
   nzGxy=sum(Gxy~=0,2);
   fzGxx= nzGxx~=3;
   fzGyy= nzGyy~=3;
   fzGxy= nzGxy~=4;
   Gxx(fzGxx,:)=0;
   Gyy(fzGyy,:)=0;
   Gxy(fzGxy,:)=0;
end
