%% //Read in images
clc;               % Clear the command window.
close all;         % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures if you have the Image Processing Toolbox.
clear;             % Erase all existing variables. Or clearvars if you want.
workspace;         % Make sure the workspace panel is showing.

rgbImage = imread('F:/final_project/banknote_detection/images/real_1000/front/1395/9.jpg');

% Get the dimensions of the image.  numberOfColorChannels should be = 3.
[rows, columns, numberOfColorChannels] = size(rgbImage);

% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);

hsvImage = rgb2hsv(rgbImage);
sImage = hsvImage(:, :, 2);

% Threshold.
mask = sImage > 0.1;
% Extract biggest blob.
mask = bwareafilt(mask, 1);
% Fill holes.
mask = imfill(mask, 'holes');

% Get bounding box.
props = regionprops(logical(mask),'BoundingBox');

% Crop image.
croppedImage = imcrop(rgbImage, props.BoundingBox);

% Resize
resize = imresize(croppedImage,[1056 2481]);

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
feature4 = imcrop(normal,[1950 60 240 220]);
bw4      = imbinarize(feature4);  
% numBlak4 = nnz(~bw4);

% Texture Feature->(glcm-gray level co occurrence matrix)
glcm        = graycomatrix(normal);
contrast    = graycoprops(glcm,{'contrast'});
correlation = graycoprops(glcm,{'correlation'});
energy      = graycoprops(glcm,{'energy'});
homogeneity = graycoprops(glcm,{'homogeneity'});

% Shape Feature
fet2 = hu_moments(bw1);
fet3 = hu_moments(bw2);
fet4 = hu_moments(bw3);
fet5 = hu_moments(bw4);

imshow(bw4);

