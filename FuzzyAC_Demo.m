%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of "A robust fuzzy region-based active contours with saliency-aware
% prior for image segmentation"
% Jiangxiong Fang
% code at : https://github.com/fangchj2002/FRACSP
% East China University of Technology & Nanchang university
% Email:fangchj2002@163.com
% 6th, May, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;
clear;
close all;
addpath 'images'
Img = imread('86016.jpg'); 
tic;

Img_gray = rgb2gray(Img);

iterNum = 100;
lambda1 = 0.5;
lambda2 = 0.5;
alpha1 = 0.1;
alpha2 = 0.1;

[M,N] = size(Img_gray);
u = zeros(M,N);
u(:,:) = 0.25;
u(40:60,60:80) = 0.75;

G = [1/(1+sqrt(2)) 0.5 1/(1+sqrt(2));0.5 8 0.5;1/(1+sqrt(2)) 0.5 1/(1+sqrt(2))];

figure;subplot(2,2,1);imshow(Img);hold on;%axis off,axis equal
title('Initial contour');
[c,h] = contour(u-0.5,[0 0],'r');

saliency = Saliency(Img);

subplot(2,2,2);
imshow(saliency,[]);hold on;
subplot(2,2,3);
%energy = zeros(100);
energy1 = [];
dltf1= [];

% set the parameter as follow

pause(0.1);
% start level set evolution
for n=1:iterNum
    [u,e,deltaF] = fuzzy_RegionEdge(u, double(Img_gray),G,double(saliency),lambda1,lambda2,alpha1,alpha2); 
    energy1(n) = e;
    dltf1(n) = deltaF;
    if mod(n,5)==0
        pause(0.1);
        imshow(Img, []);hold on;axis off,axis equal
        [c,h] = contour(u-0.5,[0 0],'r');
        iterNum=[num2str(n), ' iterations'];
        title(iterNum);
        hold off;
    end
end
subplot(2,2,4);
seg = ((u-0.5)>0);
imshow(seg);

totalIterNum=[num2str(n), ' iterations'];
title(['Final contour, ', totalIterNum]);
time = toc;
figure;

mesh(u-0.5);
title('Final level set function');



