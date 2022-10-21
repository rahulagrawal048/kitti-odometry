
T_final = bunny_transformations('bun_zipper_res2.ply', true)

function T_final = bunny_transformations(file_name, save_fig)
if nargin < 2
    save_fig = false;
    if nargin < 1
        % use the default point cloud
        file_name = 'bun_zipper_res2.ply';
    end
end

% read the point cloud
xyz0 = read_bunny(file_name);

%% Write your code here:
s = [1 1 1.2]';
T1 = mtx_scale(s);
n = [0 0 -120*pi/180]';
T2 = mtx_rotate(n);
n = 150*pi/180*[1 0 0]';
a = [0 0 -0.5]';
T3 = mtx_rotate(n,a);
t = [0 0.4 0.8]';
T4 = mtx_translate(t);

%%
T_final = T4*T3*T2*T1;

%% visualization
% visualization
%uncomment following code block to help visualize
%only run on local matlab
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% VISUALIZATION START %%%%%%%%%%%%%%%%%%%
figure(3); clf();
set(gcf, 'Position', [200, 200, 800, 400])

ax1 = subplot(1, 2, 1);
visualize_bunny(xyz0, xyz0(3, :))
title('Original')

ax2 = subplot(1, 2, 2);
visualize_bunny(T_final * xyz0, xyz0(3, :));
title('Transformed')

link = linkprop([ax1, ax2], ...
   {'CameraUpVector', 'CameraPosition', 'CameraTarget', ...
   'XLim', 'YLim', 'ZLim'});
setappdata(gcf, 'StoreTheLink', link);

%
if save_fig
   set(gcf, ...
       'PaperPositionMode', 'Auto', ...
       'PaperUnits', 'Inches', ...
       'PaperSize', [8, 4], ...
       'Renderer', 'Painters')
   print('hw1_p4_3.pdf', '-dpdf', '-fillpage')
   set(gcf, 'Renderer', 'opengl')
end
%%%%%%%%% VISUALIZATION END %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%%
function xyz = read_bunny(file_name)
% read the ply file
pc = pcread(file_name);
xyz = pc.Location.';

% resize the bunny to fit into a unit cube
ub = max(xyz, [], 2);
lb = min(xyz, [], 2);
xyz = xyz - (ub + lb) / 2;
xyz = 2 * xyz / max(ub - lb);

% convert to homogeneous coordinates and rotate to an upright posture
xyz = mtx_rotate([pi / 2; 0; 0]) * [xyz; ones(1, size(xyz, 2))];
end

%%
function visualize_bunny(xyz, cmap)
pcshow(xyz(1:3, :).', reshape(cmap, 1, []))
axis equal; axis([-1, 1, -1, 1, -1, 1] * 1.5)
xlabel('x'); ylabel('y'); zlabel('z')
end

function T_t = mtx_translate(t)
%% Write your code here:
T_t = [eye(3,3) t;
       zeros(1,3) 1];

end

function T_r = mtx_rotate(n, a)
%% Write your code here:
    if nargin < 2
        a = [0 0 0]';
    end
    theta = norm(n);
    if theta ~= 0
        k_hat = (1/norm(n))*n;
        K = [0 -k_hat(3) k_hat(2);
            k_hat(3) 0 -k_hat(1);
            -k_hat(2) k_hat(1) 0];
        R = eye(3,3) + sin(theta)*K + (1 - cos(theta))*K*K;
    else
        R = eye(3,3);
    end
    R_h = [R zeros(3,1);
           zeros(1,3) 1];
    T_r = mtx_translate(a)*R_h*mtx_translate(-a);
end

function T_s = mtx_scale(s, a)
%% Write your code here:
    if nargin < 2
        a = [0 0 0]';
    end
    T_scale = [diag(s) zeros(3,1);
               zeros(1,3) 1];
    T_s = mtx_translate(a)*T_scale*mtx_translate(-a);
end