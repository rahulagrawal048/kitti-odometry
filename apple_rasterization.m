        
function new_image = apple_rasterization(T, original_image, new_size)
if nargin < 3
    % default size (height, width)
    new_size = [450, 400];
    if nargin < 2
        % default image
        original_image = imread('apple.png');
        if nargin < 1
            % default transformation
            a = [225; 200; 0];
            T = mtx_translate([150; 125; 0]);
            T = mtx_scale([1.5; 1.5; 1], a) * T;
            T = mtx_rotate([0; 0; deg2rad(30)], a) * T;

            % Note:
            %   This is not the same homography matrix as the output of
            %   'apple_transformations'. To rasterize the image with the
            %   homography matrix from the previous problem, run
            %   T = apple_transformations();
            %   new_apple = apple_rasterization(T);

        end
    end
end

[h0, w0, d0] = size(original_image);
new_image = uint8(zeros(new_size(1), new_size(2), d0));

%% Write your code here:
T = apple_transformations();
for i = 1:new_size(2)
     for j = 1:new_size(1)
         pts = inv(T)*[i - 1,j - 1,0,1]';
         pts = round(pts);
         if(pts(1) < w0 && pts(1) >= 0 && pts(2) < h0 && pts(2) >=0)
             new_image(j,i,:) = original_image(pts(2) + 1, pts(1) + 1,:);
         end
     end
end
        
        

%%
imwrite(new_image, 'rasterized.png')

%% visualization
figure(2); clf()
set(gcf, 'Position', [150, 150, 800, 400])

corners = [
    0, w0 - 1, w0 - 1, 0, 0
    0, 0, h0 - 1, h0 - 1, 0
    zeros(1, 5)
    ones(1, 5)
];

ax1 = subplot(1, 2, 1);
visualize_apple(original_image, new_size, corners);

ax2 = subplot(1, 2, 2);
visualize_apple(new_image, new_size, T * corners);

linkaxes([ax1, ax2]);
end

%%
function visualize_apple(image, grid_size, corners)
[h, w, ~] = size(image);
imagesc(image, 'XData', [0, w - 1], 'YData', [0, h - 1]);

hold on
plot(corners(1, :), corners(2, :), 'r')
hold off

axis equal; axis([0, grid_size(2), 0, grid_size(1)])
xlabel('x'); ylabel('y')
end
