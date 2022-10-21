function features = get_features(image)
%% Write your code here:
points = detectSURFFeatures(image)
[features, validPoints] = extractFeatures(image,points);
features = double(features);
end