%% this is the optional script for testing q1.4

data2test = 'velodyne_straight_small.mat';

[T_rel,T_total] = kitti_icp(data2test);
[T_rel_ref,T_total_ref] = kitti_icp_ref(data2test);
