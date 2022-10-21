%% this is the optional script for testing q1.2

w_radius = 4;
max_d = 64;
min_d = 0;

%% test at t0
I0_l = imread('t0_left.png');
I0_r = imread('t0_right.png');
% Run learner solution.
[D_t0]=genDisparityMap(I0_l, I0_r, min_d, max_d, w_radius);
[D_t0_ref]=genDisparityMap_ref(I0_l, I0_r, min_d, max_d, w_radius);
accuracy_t0 = sum(sum((D_t0 - D_t0_ref).^2 < eps)) / numel(D_t0)

%% test at t0
I1_l = imread('t1_left.png');
I1_r = imread('t1_right.png');
% Run learner solution.
[D_t1]=genDisparityMap(I1_l, I1_r, min_d, max_d, w_radius);
[D_t1_ref]=genDisparityMap_ref(I1_l, I1_r, min_d, max_d, w_radius);
accuracy_t1 = sum(sum((D_t1 - D_t1_ref).^2 < eps)) / numel(D_t1)