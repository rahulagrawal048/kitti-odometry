% this is the optional script for testing q1.2 and q1.3

% You will need computer vision toolbox to visualize pointcloud. If you do
% not have this toolbox, set this option to false to avoid runtime error.
visualize_PC = true;
%% load data
% you can change to any desired 'velodyne_xx.mat'.
velodyne = load('velodyne_turn.mat');
pc_body = velodyne.data;
num_clouds = size(pc_body, 1);

% get two consecutive point cloud for testing
% replcae idx with any int between [1,num_clouds-1] if you want
idx = randi([1,num_clouds-1]);
pc1 = pc_body{idx};
pc2 = pc_body{idx+1};

%% test 1.2 naive ICP
%initialize
T_init = eye(4);
T_init(1, 4) = 1;

% ICP results
use_naive = true;
T_final_naive=icp(pc1, pc2, use_naive, T_init);
T_final_naive_ref = icp_ref(pc1, pc2, use_naive, T_init);

if visualize_PC
    visualize_icp(pc1, pc2, T_final_naive, 'Naive ICP');
    visualize_icp(pc1, pc2, T_final_naive_ref, 'Naive ICP reference');
end

%% test 1.3 weighted ICP
% ICP results
use_naive = false;
T_final_weight=icp(pc1, pc2, use_naive, T_init);
T_final_weight_ref = icp_ref(pc1, pc2, use_naive, T_init);

if visualize_PC
    visualize_icp(pc1, pc2, T_final_weight, 'Weighted ICP');
    visualize_icp(pc1, pc2, T_final_weight, 'Weighted ICP reference');
end

%% visualize help function
function visualize_icp(p_origin, p_tofit, T_final, title_str)
    figure
    pc1 = pointCloud(p_origin');
    pc2 = pointCloud(p_tofit');
    pcshowpair(pc1,pctransform(pc2,affine3d(T_final')))
    title(title_str);
end