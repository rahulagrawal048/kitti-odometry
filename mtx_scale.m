function T_s = mtx_scale(s, a)
%% Write your code here:
    if nargin < 2
        a = [0 0 0]';
    end
    T_scale = [diag(s) zeros(3,1);
               zeros(1,3) 1];
    T_s = mtx_translate(a)*T_scale*mtx_translate(-a);
end
