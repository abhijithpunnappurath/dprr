function [ssd_min,ssd_disp,ssd_neigh] = compute_ssd(img1,img2,r,win)

[row,col]=size(img1);

% append zeros to second image
img2b=Inf*ones(size(img2,1),size(img2,2)+win*2);
img2b(:,win+1:end-win)=img2;

ssd_min = Inf*ones(row,col);
ssd_disp = zeros(row,col);
ssd_neigh = cell(row,col);

hr=win;
mid=floor(r/2);

% compute SSD
for i=1:row-r+1

    for j=1:col-r+1
        
        if(img1(i+mid,j+mid)==0 || (sum(sum(img1(i:i+r-1,j:j+r-1)))==0 || sum(sum(img2b(i:i+r-1,j-hr+hr:j+r-1+hr+hr)))==0 ) )
%         ssd_min(i+mid,j+mid)=0;
%         ssd_disp(i+mid,j+mid)=0;          
        else
        
        % loop over search window
        ssd_mat = zeros(1,hr*2+1);
        
            for q=-hr:hr
                
                ssd_mat(1,q+hr+1) = sum(sum( (img1(i:i+r-1,j:j+r-1)-img2b(i:i+r-1,j+q+hr:j+r-1+q+hr)).^2  ));
                
            end
        
        
        % find min value
        [val,ind]=min(ssd_mat);
        
        
        ssd_disp(i+mid,j+mid)=ind-hr-1;
        ssd_min(i+mid,j+mid)=val;
        
        % 3x1 neighbours for subpixel interpolation and confidence value
        if(ind~=1)
            tempvar(1)=ssd_mat(ind-1);
        else
            tempvar(1)=ssd_mat(ind);
        end
        
        tempvar(2)=ssd_mat(ind);
        
        if(ind~=length(ssd_mat))
            tempvar(3)=ssd_mat(ind+1);
        else
            tempvar(3)=ssd_mat(ind);
        end
        tempvar(isinf(tempvar))=tempvar(2);        
        ssd_neigh{i+mid,j+mid}=tempvar;

        
        end
    end
end
