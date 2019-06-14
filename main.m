% Reflection removal using a dual-pixel sensor
% Abhijith Punnappurath and Michael S. Brown
% CVPR 2019, Long Beach, California

% Author: Abhijith Punnappurath, York University, Toronto, Canada
% Email: pabhijith@eecs.yorku.ca

clc;
clear;
close all;

addpath(genpath('Functions'));

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Controlled dataset
% input_folder='../Dataset/Controlled/';
% save_folder='../Dataset/Controlled_results/';
% 
% lambda = 100;
% thresh = 1;
% p=2/3;
% iter=3;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% In-the-wild dataset
input_folder='../Dataset/In-the-wild/';
save_folder='../Dataset/In-the-wild_results/';

lambda = 100;
thresh = 0.5;
p=2/3;
iter=3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allfolders=dir(input_folder);

for i=3:length(allfolders)
mkdir([save_folder allfolders(i).name]);
mixLc = imread([input_folder allfolders(i).name '/left.png']); 
mixRc = imread([input_folder allfolders(i).name '/right.png']);
input_img = imread([input_folder allfolders(i).name '/input.png']);
            
fprintf('%s \n',allfolders(i).name);

tic
[back,ref] = dual_pixel_ref_removal(mixLc,mixRc,input_img,lambda,thresh,p,iter);
myt=toc;
fprintf('Elapsed time: %f \n',myt/60);

imwrite(back,[save_folder allfolders(i).name '/back.png'])
imwrite(ref,[save_folder allfolders(i).name '/ref.png'])

end