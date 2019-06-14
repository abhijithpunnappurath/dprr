function [L1,L2] = dual_pixel_ref_removal(mixLc,mixRc,input_img,lambda,edthresh,p,iter)

[h,w,c]=size(mixLc);

if(exist(['./matG/matG_' num2str(h) '_' num2str(w) '.mat'],'file'))
    load(['./matG/matG_' num2str(h) '_' num2str(w) '.mat'])
else
[Gx,Gy,Gxx,Gxy,Gyy]=getGMat(w,h);
save(['./matG/matG_' num2str(h) '_' num2str(w) '.mat'],'Gx','Gy','Gxx','Gxy','Gyy');
end

D=[Gx; Gy; Gxx; Gxy; Gyy];

mixLun=im2double(mixLc);
mixRun=im2double(mixRc);

ws = fspecial('sobel');
thresh=0.2;

for ch = 1:3
        gx(:,:,ch) = imfilter(mixLun(:,:,ch),ws);
        gy(:,:,ch) = imfilter(mixLun(:,:,ch),ws');
end
mixLgradun = sqrt(gx.^2+gy.^2);
mixLgradun = max(mixLgradun,[],3);

mixLgradun(mixLgradun<thresh)=0;

for ch = 1:3
        gx(:,:,ch) = imfilter(mixRun(:,:,ch),ws);
        gy(:,:,ch) = imfilter(mixRun(:,:,ch),ws');
end
mixRgradun = sqrt(gx.^2+gy.^2);
mixRgradun = max(mixRgradun,[],3);

mixRgradun(mixRgradun<thresh)=0;

% sum of squared differences (SSD)
win = 5; % horizontal search half window
boxsize=11; % box size - always an odd number
[ssd_min_un,ssd_disp_un,ssd_neigh_un] = compute_ssd(mixLgradun,mixRgradun,boxsize,win);

sig_A = 5;
sig_c = 256;
[confidence_un,ssd_disp_sub_un] = compute_subpixel_displacement(ssd_neigh_un,ssd_disp_un,sig_A,sig_c,ssd_min_un);

alpha = 5;
edgeB = ssd_min_un~=Inf & abs(ssd_disp_sub_un)<=edthresh & confidence_un>1;

confidence_map=zeros(h,w);
confidence_map(edgeB)=alpha*confidence_un(edgeB);

    wt=fspecial('gaussian',[21 21],3);
    confidence_map_b=imfilter(confidence_map,wt);
    
    confidence_map_b2=confidence_map;
    confidence_map_b2(edgeB==0)=confidence_map_b(edgeB==0);

b_inds = find(confidence_map_b2>1);
conf_inds = confidence_map_b2(b_inds);

I=im2double(input_img);
imgSize=w*h;

w1=1;
w2=1;

f1=[ones(imgSize*2,1)*w1;w2*ones(imgSize*2,1);w2*ones(imgSize,1)];
f1([b_inds,b_inds+imgSize])=repmat(conf_inds,[1 2]);
f1([b_inds+imgSize*2,b_inds+imgSize*3,b_inds+imgSize*4])=repmat(conf_inds,[1 3]);
rinds1=find(sum(D~=0,2)==0);
inds=setdiff(1:size(D,1),rinds1);
D=D(inds,:);
f1=f1(inds);

warning('off');

DtD=D'*D;

df=spdiags(f1,0,length(f1),length(f1));
D1=df*D;
D1tD1=D1'*D1;

L1=zeros(h,w,c);
for cc=1:c    
Ic=I(:,:,cc);
Ic=Ic(:);

b=lambda*D1tD1*Ic;

A=lambda*D1tD1+DtD;
x=A\b;
for j=1:iter
      e=abs(D*x);
      e=max(e,0.001).^(p-2);                    
      E=spdiags(e,0,size(D,1),size(D,1));
      A=lambda*D1tD1+D'*E*D;
      x=A\b;
end
L1(:,:,cc)=reshape(x,h,w);

end

% code snippet below based on 
% Y. Li and M. S. Brown, "Single Image Layer Separation using Relative
% Smoothness", CVPR 2014
% Refer to Section 3.2 of their paper 'Normalize L1'

D=c;
lb=zeros(h,w,D);
hb=I;

%%% normalize L1
    for c = 1:D
        L1t = L1(:,:,c);
        for k = 1:500
        dt = (sum(L1t(L1t<lb(:,:,c)) )+ sum(L1t(L1t>hb(:,:,c)) ))*2/numel(L1t);
        L1t = L1t-dt;
        if abs(dt)<1/numel(L1t) 
            break; 
        end
        end
        L1(:,:,c) = L1t;
    end
    t = L1<lb;
    L1(t) = lb(t);
    t = L1>hb;
    L1(t) = hb(t);
    
    L2=I-L1;    

    L1=L1*1.5;
    L2=2*L2;
