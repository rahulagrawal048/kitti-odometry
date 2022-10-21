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
% T1 = ?;
% T2 = ?;
% T3 = ?;
% T4 = ?;

%%
T_final = T4 * T3 * T2 * T1;

%% visualization
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

%%
if save_fig
    set(gcf, ...
        'PaperPositionMode', 'Auto', ...
        'PaperUnits', 'Inches', ...
        'PaperSize', [8, 4], ...
        'Renderer', 'Painters')
    print('hw2_p4_3.pdf', '-dpdf', '-fillpage')
    set(gcf, 'Renderer', 'opengl')
end
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
