function [T_rel, T_total] = kitti_icp(file)
%% Load 3D point clouds in the body frame
if nargin == 0
   file = 'velodyne_turn.mat';
end
velodyne = load(file);
pc_body = velodyne.data;
num_clouds = length(pc_body);

%% Relative motions
T_rel = repmat(eye(4), [1, 1, num_clouds]);

% initial guess of each relative motion
T_init = eye(4);
T_init(1, 4) = 1.5;

%% Write your code here:
for k = 2:num_clouds
    T_rel(:, :, k) = icp(pc_body{k-1}, pc_body{k}, false, T_init);
end

%% Total motion
T_total = repmat(T_rel(:, :, 1), [1, 1, num_clouds]);

%% Write your code here:
for k = 2:num_clouds
   T_total(:, :, k) = T_total(:,:,k-1)*T_rel(:,:,k);
end

disp(T_total)

%% Visulization
figure
clf()

pc_world = cell(num_clouds, 1);

for k = 1:num_clouds
    R = T_total(1:3, 1:3, k);
    t = T_total(1:3, 4, k);
    pc_world{k} = R * pc_body{k} + t;
end

pc_world = cell2mat(pc_world');
pcshow(pc_world')
caxis(prctile(pc_world(3, :), [1, 99]))
grid on
axis equal

zlim([-10, 10])
view(2)

traj_xyz = squeeze(T_total(1:3, 4, :));
hold on
plot3(traj_xyz(1, :), traj_xyz(2, :), traj_xyz(3, :), ...
    'r.-', 'MarkerSize', 8)
title('VO trajectory')
hold off
end
