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
