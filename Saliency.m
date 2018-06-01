%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of "A robust fuzzy region-based active contours with saliency-aware
% prior for image segmentation"
% Jiangxiong Fang
% code at : https://github.com/fangchj2002/FRACSP
% East China University of Technology & Nanchang university
% Email:fangchj2002@163.com
% 6th, May, 2018
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function saliency = Saliency(img)
%gfrgb = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');
gfrgb = imfilter(img, fspecial('gaussian',[10 10],3), 'same', 'conv');
%gfrgb = imfilter(img, fspecial('disk'), 'same', 'conv');

[l, a, b]= rgb2lab(gfrgb);

lm = mean(mean(l));
am = mean(mean(a));
bm = mean(mean(b));
sm = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
saliency = sm;
end

