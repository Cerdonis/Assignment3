clear
clc
task_EX2
close all

im1_crop_color = im1_crop;
im2_crop_color = im2_crop;

save('im1_crop_color.mat','im1_crop_color');

% Color image was converted to grayscale.
im1_crop = rgb2gray(im1_crop);
im2_crop = rgb2gray(im2_crop);
im1_crop = im2double(im1_crop);
im2_crop = im2double(im2_crop);


[r c] = size(im1_crop);
disparity_ssd = zeros(r, c);

win = 6; % 'Radius' of window size
lim = 40; % Maximum limit of disparity. Added for faster running. 

for i=win+1:r-win 
    for j=win+1:c-win

        ncc_max = 0;
        ssd_min = 9999999;
        % Acquire window from first image
        patch1 = PATCH(win*2+1, i, j, im1_crop);
         
         for k=j:min(j+lim, c-win)
             % Acquire window from second image image
             patch2 = PATCH(win*2+1, i, k, im2_crop);
             
             sd = patch1 - patch2;
             temp_min = sum(sd(:).^2);
             
            % Save the disparity that makes the best SSD match.
             if ssd_min > temp_min
                 ssd_min = temp_min;
                 disparity_ssd(i,j) = k-j;
             end             
         end
         
         % Two points flanking the original point of best match
         i_l = max(j+disparity_ssd(i,j)-1, j);
         i_r = min(j+disparity_ssd(i,j)+1, c-win);
         c_0 = -ssd_min;
         
         % Acquire negative SSD values from the two points
         patch_i_l = PATCH(win*2+1, i, i_l, im2_crop);
         sd = patch1 - patch_i_l;
         c_l = -sum(sd(:).^2);         
         patch_i_r = PATCH(win*2+1, i, i_r, im2_crop);
         sd = patch1 - patch_i_r;
         c_r = -sum(sd(:).^2);
         
         % Apply refinement formula
         x = (c_r-c_l)/(2*(c_0-min(c_r, c_l)));
         
         disparity_ssd(i,j) = disparity_ssd(i,j) + x;
         
    end
end

save('disparity_ssd.mat','disparity_ssd');

% Convert the disparity map to 'double'
disparity_ssd=disparity_ssd/max(max(disparity_ssd));

figure; imshow(disparity_ssd)
title('Refined SSD disparity');
colormap(gca,parula) 
colorbar





