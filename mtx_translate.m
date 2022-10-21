function T_t = mtx_translate(t)
%% Write your code here:
    T_t = [eye(3,3) t;
       zeros(1,3) 1];
end
