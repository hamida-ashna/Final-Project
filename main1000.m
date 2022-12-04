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
Hu1       = hu_moments(bw1);
Strip_M1  = Hu1(1);
Strip_M2  = Hu1(2);
Strip_M3  = Hu1(3);
Strip_M4  = Hu1(4);
Strip_M5  = Hu1(5);
Strip_M6  = Hu1(6);
Strip_M7  = Hu1(7);

Hu2       = hu_moments(bw2);
Bottom_M1 = Hu2(1);
Bottom_M2 = Hu2(2);
Bottom_M3 = Hu2(3);
Bottom_M4 = Hu2(4);
Bottom_M5 = Hu2(5);
Bottom_M6 = Hu2(6);
Bottom_M7 = Hu2(7);

Hu3       = hu_moments(bw3);
Upper_M1  = Hu3(1);
Upper_M2  = Hu3(2);
Upper_M3  = Hu3(3);
Upper_M4  = Hu3(4);
Upper_M5  = Hu3(5);
Upper_M6  = Hu3(6);
Upper_M7  = Hu3(7);

Hu4       = hu_moments(bw4);
Logo_M1   = Hu4(1);
Logo_M2   = Hu4(2);
Logo_M3   = Hu4(3);
Logo_M4   = Hu4(4);
Logo_M5   = Hu4(5);
Logo_M6   = Hu4(6);
Logo_M7   = Hu4(7);


imshow(bw4);
