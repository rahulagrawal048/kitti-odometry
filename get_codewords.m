function codewords = get_codewords(feature_all, num_codewords, seed)
if nargin == 3
    rng(seed);
end

%% Write your code here:
[IDX, C] = kmeans(feature_all, num_codewords,'MaxIter', 500);
codewords = C;
end
