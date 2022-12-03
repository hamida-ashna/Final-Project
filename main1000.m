%% //Read in images
clc;               % Clear the command window.
close all;         % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;             % Erase all existing variables. Or clearvars if you want.
workspace;         % Make sure the workspace panel is showing.

move  = imread('F:/final_project/dataset/Money Scanned/New folder/banknote_images/real_1000/fake1.jpg');
fixed = imread('F:/final_project/dataset/Money Scanned/New folder/banknote_images/real_1000/test.jpg');

% Align and Crop 
[optimizer, metric] = imregconfig('multimodal');
tform = imregtform(rgb2gray(move),rgb2gray(fixed), 'similarity', optimizer, metric);
movingRegistered = imwarp(move,tform,'OutputView',imref2d(size(fixed)));

% Resize
resize = imresize(movingRegistered,[1056 2481]);

% Smoothening(removing noise)
filter = wiener2(rgb2gray(resize));

% Normalization 
normal = uint8(255*mat2gray(filter));

% Feature 1->(security strip)
feature1 = imcrop(normal,[675 0 210 2481]);
bw1      = imbinarize(feature1);

% Feature 2->(bottom design)
feature2 = imcrop(normal,[680 799 1045 170]);
bw2      = imbinarize(feature2);

% Feature 3->(upper design) 
feature3 = imcrop(normal,[790 47 835 190]);
bw3      = imbinarize(feature3);
% numBlak3 = nnz(~bw3);

% Feature 4->(logo) [1940 90 255 220]
feature4 = imcrop(normal,[1965 45 240 220]);
bw4      = imbinarize(feature4);  
% numBlak4 = nnz(~bw4);

% Texture Feature->(glcm-gray level co occurrence matrix)
[glcm,si]=graycomatrix(normal);
% fet3=glcm(:);
fet1 = graycoprops(glcm,{'contrast','correlation','energy','homogeneity'});

% Shape Feature
fet2 = hu_moments(bw1);
fet3 = hu_moments(bw2);
fet4 = hu_moments(bw3);
fet5 = hu_moments(bw4);

imshow(bw4);
