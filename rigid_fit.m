function [R, t] = rigid_fit(p1, p2, weight)
%% Fit a rigid body transformation [R, t] by solving
%
%       \min    sum(w(i)* norm(R * p1(:, i) + t - p2(:, i) )^2)
%
%   Reference: https://igl.ethz.ch/projects/ARAP/svd_rot.pdf
size(p1)
size(p2)
assert(isequal(size(p1), size(p2)))
assert(size(p1, 1) <= size(p1, 2))

if nargin < 3
    weight = ones(size(p1, 2), 1);
end

assert(all(weight >= 0))

%% reshape and normalize
weight = reshape(weight, [], 1);
weight = weight / sum(weight);

%% Write your code here:
p1_bar = (1/sum(weight))*[sum(p1(1,:).*weight'); sum(p1(2,:).*weight'); sum(p1(3,:).*weight')];
p2_bar = (1/sum(weight))*[sum(p2(1,:).*weight'); sum(p2(2,:).*weight'); sum(p2(3,:).*weight')];
X = p1 - [p1_bar(1)*ones(1,size(p1, 2));
          p1_bar(2)*ones(1,size(p1, 2));
          p1_bar(3)*ones(1,size(p1, 2));];
Y = p2 - [p2_bar(1)*ones(1,size(p1, 2));
          p2_bar(2)*ones(1,size(p1, 2));
          p2_bar(3)*ones(1,size(p1, 2));];
S = X*diag(weight)*Y';
[U,Sigma,V] = svd(S);
R = V*[eye(2,2) zeros(2,1);
        0 0 det(V*U')]*U';
t = p2_bar - R*p1_bar;

end


