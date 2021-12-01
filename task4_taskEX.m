clear
clc
task2
close all

load('disparity_ssd.mat') % Please run task_3 or task_EX first
load('im1_crop_color')

f = (K(1,1)+K(2,2))/2; % Focal length
b = norm(axis_x); % Length of baseline

[r c] = size(disparity_ssd);

point_storage = zeros(786432, 6); % Pre-allocated matrix for 3D coordinate & RGB value
quant = 0;
counter = 0;

for i=1:r
    for j=1:c
        if disparity_ssd(i,j) == 0 % Discarding outliers
            continue   
        end
        counter = counter+1;
        if mod(counter,5) ~= 0 % Reducing volume of point cloud
            continue   
        end
        quant = quant+1;
        z = f*b/disparity_ssd(i,j);
        point_storage(quant, 1) = z;
        point_storage(quant, 2) = j*z/f;
        point_storage(quant, 3) = i*z/f;
        point_storage(quant, 4) = im1_crop_color(i, j, 1);
        point_storage(quant, 5) = im1_crop_color(i, j, 2);
        point_storage(quant, 6) = im1_crop_color(i, j, 3);        
    end
end

point_storage = point_storage(1:quant,:);

save('point_storage.mat','point_storage');



