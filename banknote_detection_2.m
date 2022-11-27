%% read image
clc;               % Clear the command window.
close all;         % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;             % Erase all existing variables. Or clearvars if you want.
workspace;         % Make sure the workspace panel is showing.

% rgbImage = imread('F:/final_project/dataset/Money Scanned/New folder/banknote_images/real_1000/front/35.jpg');
rgbImage = imread('F:/final_project/dataset/Money Scanned/New folder/banknote_images/real_500/front/52.jpg');
temp = imread('E:/diff/1395/real_4_2.jpg');
% Get the dimensions of the image.  numberOfColorChannels should be = 3.
[rows, columns, numberOfColorChannels] = size(rgbImage);

% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

hsvImage = rgb2hsv(rgbImage);
sImage = hsvImage(:, :, 2);

histogram(sImage);
grid on;

% Threshold.
mask = sImage > 0.1;
% Extract biggest blob.
mask = bwareafilt(mask, 1);
% Fill holes.
mask = imfill(mask, 'holes');

% Get bounding box.
props = regionprops(logical(mask), 'BoundingBox');

% Crop image.
croppedImage = imcrop(rgbImage, props.BoundingBox);

% Resize
resize = imresize(croppedImage,[1056 2481]);

% Feature(1)
feature1 = imcrop(resize,[680 0 230 2481]);
gray1    = rgb2gray(feature1);
adjust1  = imadjust(gray1); 
filter1  = wiener2(adjust1);
bw1      = imbinarize(filter1);
% adjust1  = rgb2hsv(feature1); 


% Feature (2)
feature2 = imcrop(resize,[680 770 1045 200]);
gray2    = rgb2gray(feature2);
adjust2  = imadjust(gray2); 
filter2  = wiener2(adjust2);
bw2      = imbinarize(filter2);
% f2 = imgaussfilt(gray2);
imshow(bw2);


%   Real 1000
%   Fake 1000
% Fake >  < Real
%   Real 500
%   Fake 500


% Feature (3) 790 80 825 190
feature3 = imcrop(resize,[790 80 875 190]);
gray3    = rgb2gray(feature3);
adjust3  = imadjust(gray3); 
% filter3  = wiener2(adjust3);
bw3      = imbinarize(adjust3);
numBlak3 = nnz(~bw3);


% 89774,91002,95300,86638,90381,92839,68038,64582  Real 1000
% 99210,103674  Fake 1000
% Fake > 96000 < Real
% 78798,61842,63427 Real 500
% 96025 Fake 500

% Feature (4)   ========> solved [1940 90 255 220]
feature4 = imcrop(resize,[1910 85 240 220]);
gray4    = rgb2gray(feature4);
adjust4  = imadjust(gray4); 
filter4  = wiener2(adjust4);
bw4      = imbinarize(filter4);
% numberOFTruePixels = numel(bw4); "" Total pixels
% num= nnz(bw4);                   "" White pixels  
numBlak4 = nnz(~bw4);


% 18911, 15160, 16142, 18992, 15750 REAL 1000  
% 22171 Fake 1000
% Fake > 2000 < Real
% 19319, 14581, 14656   REAL 500
% 24450  Fake 500 
 




% % Feature (5)
% feature5 = imcrop(resize,[170 740 350 240]);
% gray5    = rgb2gray(feature5);
% adjust5  = imadjust(gray5); 
% filter5  = wiener2(adjust5);
% % bw5      = imbinarize(filter5);
% % 21844;55517 \\ 26691;50670\\ real= 17442;59919\\ [21301;56060] \\ [20247;57114]
% 
% edim = edge(bw3, 'canny');
% % imshow(edim);
% %find histogram
% % ed = imhist(bw2(:));
% edhist = imhist(edim(:));
% [hog_4x4,vis4x4] = extractHOGFeatures(edim,'CellSize',[4 4]);
% % 
% % [182427;27819]
% % plot(vis4x4); 
% % imshow(adjust3);
%  %texture feature
%  %glcm-gray level co occurrence matrix
%  [glcm,si]=graycomatrix(rgb2gray(feature3));
%  fet3=glcm(:);
%  status = graycoprops(glcm,{'contrast','correlation','energy','homogeneity'});
% % imshow(rescale(si));
% % 1- 0.5150, 0.7542, 0.5977,0.6210
% % 2- 0.8089
% 
% % imshow(feature4); 
% % a = double(gray4);
% % b = double(temp);
% % err = immse(gray4,temp);
% % a = imresize(gray4,[548 636]);
% b        = rgb2gray(temp);
% adjust   = imadjust(b); 
% filter  = wiener2(adjust);
% 
% a = imresize(filter4,[448 636]);
% b2 = imresize(filter,[448 636]);
% 
% Compare = normxcorr2(imbinarize(b2),imbinarize(a)); %Finding the correlation between two images
% if (Compare==1)
%      disp('images are same')
% else
%     disp('images are not same')
% end;
% imshow(imbinarize(b2)); 