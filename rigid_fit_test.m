[p1, p2, R, t] = gen_points(1000, 0.01);
disp([R, t]);   % ground truth
[R1, t1] = rigid_fit(p1, p2);
disp([R1, t1]);