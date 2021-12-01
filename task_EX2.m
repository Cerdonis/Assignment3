clear
close all
clc

orig1 = imread('undistorted00000124.jpg');
ext1 = readmatrix('camera00000124.txt');

orig2 = imread('undistorted00000127.jpg');
  ext2 = readmatrix('camera00000127.txt');

K = readmatrix('Calibration.txt');

load('R_rect.mat');


R1 = ext1(:, 1:3);
t1 = ext1(:, 4);
R2 = ext2(:, 1:3);
t2 = ext2(:, 4);

% Calculate camera centers
cam_c1 = -inv(R1) * t1;
cam_c2 = -inv(R2) * t2;

% % new x axis (Baseline)
% axis_x =  R1*(cam_c1 - cam_c2);
% % new y axis (orthogonal to baseline and included in XY plane)
% axis_y =[-axis_x(2) axis_x(1) 0]';
% % new z axis (orthogonal to y axis & baseline)
% axis_z = cross(axis_x,axis_y);
% 
% % Calculate rectifying rotation matrix
% R_rect = [axis_x'/norm(axis_x); axis_y'/norm(axis_y); axis_z'/norm(axis_z)];

% save('R_rect.mat', 'R_rect');

% Final tramsformation matrix
R2 = R_rect * R1 * inv(R2);
tf1 = K * R_rect * inv(K);
tf2 = K * R2 * inv(K);

T1 = projective2d(tf1');
T2 = projective2d(tf2');

% Warp each color channels
im1_R = imwarp(orig1(:,:,1), T1);
im1_G = imwarp(orig1(:,:,2), T1);
im1_B = imwarp(orig1(:,:,3), T1);
im2_R = imwarp(orig2(:,:,1), T2);
im2_G = imwarp(orig2(:,:,2), T2);
im2_B = imwarp(orig2(:,:,3), T2);

im1 = cat(3, im1_R, im1_G, im1_B);
im2 = cat(3, im2_R, im2_G, im2_B);
figure; imshow(im1)
figure; imshow(im2)

% Crop out resulting black triangles
% [im1_crop, top1, bot1] = CROP2(im1);
im1_crop = im1;
im2_crop = im2;

[r1 c1 z1] = size(im1_crop);
[r2 c2 z2] = size(im2_crop);

% Two cropped images have different sizes. Make them same.
diff = abs(r1-r2);
diff_half = ceil(diff/2);
diff_rest = diff-diff_half;

if r1 > r2
    im1_crop = im1_crop(1+diff_half:r1-diff_rest, :, :);
else
    im2_crop = im2_crop(1+diff_half:r2-diff_rest, :, :);
end

diff = abs(c1-c2);
diff_half = ceil(diff/2);
diff_rest = diff-diff_half;

if c1 > c2
    im1_crop = im1_crop(:, diff_half+1 : c1-diff_rest, :);
else
    im2_crop = im2_crop(:, diff_half+1 : c2-diff_rest, :);
end
    
merge = [im1_crop im2_crop];
orig = [orig1 orig2];

% Can adjust horizontal line gap.
gap = 20;

% Visualize before and after rectification.
[r c] = size(orig);

figure; imshow(orig)
title('Before rectification');
hold on;
for i = 1:floor(r/gap)
    yline(gap*i, 'r')
end
hold off;

[r c] = size(merge);

figure; imshow(merge)
title('After rectification');
hold on;
for i = 1:floor(r/gap)
    yline(gap*i, 'r')
end
hold off;
