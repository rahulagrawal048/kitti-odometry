function h = get_hist(codewords, features)
%% Write your code here:
num_codewords = size(codewords, 1);
IDX = knnsearch(codewords,features);
h = groupcounts(IDX)'./size(features,1);
% `h` must be a row vector
assert(isequal(size(h), [1, num_codewords]))

% `h` must be normalized
assert((sum(h) - 1)^2 < eps)
end
