function [D] = genDisparityMap(I1, I2, min_d, max_d, w_radius)
% INPUT
%   I1 the left stereo image
%   I2 the right stereo image
%   min_d minimum disparity
%   max_d maximum disparity
%   w_radius the radius of the window to do the AD aggeration
%
% OUTPUT
%   D disparity values

if nargin < 5, w_radius = 4; end % 9x9 window
if nargin < 4, max_d = 64; end
if nargin < 3, min_d = 0; end

% Grayscale Images are sufficient for stereo matching
% The Green channel is actually a good approximation of the grayscale, we
% could instad do I1 = I1(:,:,2);
if size(I1, 3) > 1, I1 = rgb2gray(I1); end
if size(I2, 3) > 1, I2 = rgb2gray(I2); end

% convert to double/single
I1 = double(I1);
I2 = double(I2);

%% Calculate SAD values for each pixel in the Left Image.
%% Write your code here:
kernel = ones(2*w_radius + 1);

%%
% the range of disparit y values from min_d to max_d inclusive
d_vals = min_d:max_d;
%% Write your code here:
% D is the Disparity Matrix and is the same size as that of the Images.
I1_pad = padarray(I1, [w_radius w_radius],0,'both');
I2_pad = padarray(I2, [w_radius w_radius],0,'both');
minSSD = ones(size(I1))*100000;
D = ones(size(I1));
for dvals = min_d:max_d
    I2_trans = imtranslate(I2_pad, [dvals 0]);
    abs_diff = imabsdiff(I1_pad,I2_trans);
    ssd = conv2(abs_diff,kernel,'valid');
    for i = 1:size(I1,1)
        for j = 1:size(I1,2)
            if (ssd(i,j) < minSSD(i,j))
                minSSD(i,j) = ssd(i,j);
                D(i,j) = dvals;
            end
        end
    end
end
            
    
%% Visualize disparity map
figure;
imagesc(D, [0, max_d]);
colormap(gray);
colorbar;
axis image;
title('Disparity Map');
end
