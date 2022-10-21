function T_final = icp(p_t, p_s, use_naive, T_init)

m = size(p_t, 1);

if nargin < 4
    T_init = eye(m + 1);
    if nargin < 3
        use_naive = true;
    end
end

delta = inf;
T_final = T_init;
while delta > sqrt(eps)
    p1 = T_final(1:m, 1:m) * p_s + T_final(1:m, m + 1);

    %% Write your code here:
    idx = knnsearch(p_t',p1');
    p2 = p_t(:,idx);

    if use_naive
        weight = ones(size(p1, 2), 1);
    else

        %% Write your code here:
        d = zeros(1,1000);
        for i = 1:size(p2,2)
            d(1,i) = norm(p1(:,i) - p2(:,i));
        end
        std_dev = std(d);
        weight = zeros(size(p1, 2), 1);
        for i = 1:size(p1,2)
            weight(i,1) = exp(-d(1,i)^2/std_dev^2);
        end

    end

    % incremental transformation
    [delta_R, delta_t] = rigid_fit(p1, p2, weight);

    %% Write your code here:
    % update T_final with `delta_R` and `delta_t`
    T_final(1:m,1:m) = T_final(1:m,1:m) * delta_R;
    T_final(1:m, m + 1) = T_final(1:m, m + 1) + delta_t;
    delta = norm([delta_R - eye(m), delta_t]);
end

end
