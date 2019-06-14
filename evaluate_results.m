% Reflection removal using a dual-pixel sensor
% Abhijith Punnappurath and Michael S. Brown
% York University, Toronto, Canada
% CVPR 2019, Long Beach, California

% Author: Abhijith Punnappurath, York University
% Email: pabhijith@eecs.yorku.ca

clc;
clear;
close all;

addpath(genpath('Evaluation_metrics'));

gt_path = '../Dataset/Controlled/';
res_path = '../Dataset/Controlled_results/';

alldir=dir(res_path);

w = 50;

for i=3:length(alldir)
    
    fprintf('%d of %d \n',i-2,length(alldir)-2);
    
    gt=imread([gt_path alldir(i).name '/gt.png']);
    res=imread([res_path alldir(i).name '/back.png']);
   
     % PSNR
    PSNR_array(i-2)=mypsnr(gt,res);
    
    % SSIM
    SSIM_array(i-2)=ssim(gt,res);
        
    % sLMSE
    sLMSE_array(i-2)=lmse(gt,res,w);
    
    % NCC
    NCC_array(i-2)=xcorr_normalized_color(gt,res);
    
    % SI
    SI_array(i-2)=si(gt,res);    
    
end

fprintf('\n \n');
fprintf('PSNR - %f \n', mean(PSNR_array));
fprintf('SSIM - %f \n', mean(SSIM_array));
fprintf('sLMSE - %f \n', mean(sLMSE_array));
fprintf('NCC - %f \n', mean(NCC_array));
fprintf('SI - %f \n', mean(SI_array));