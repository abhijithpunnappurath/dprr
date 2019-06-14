function [confidence,sub_hr] = compute_subpixel_displacement(ssd_cell,hr,sig_A,sig_c,ssd_min)

confidence=zeros(size(hr));
sub_hr=zeros(size(hr));

% fit a quadratic for each pixel
for i=1:size(ssd_cell,1)
    for j=1:size(ssd_cell,2)
        
        if(ssd_min(i,j)~=Inf)
                    
        u = [hr(i,j)-1; hr(i,j); hr(i,j)+1];
        A1 = [0.5*u.^2 u ones(3,1)];
        b1 = ssd_cell{i,j}';
        x = A1\b1;
        
        a=x(1);
        b=x(2);
        c=x(3);  
        
        sub_hr(i,j)=-b/a;        
        
        confidence(i,j)=exp(log(abs(a))/sig_A - c/(sig_c^2));    
             
        end
    end
end
