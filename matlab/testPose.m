% Script for testing Pose Estimation

% Randomly generate camera matrix
K = [1, 0, 1e2; 0, 1, 1e2; 0, 0, 1];

[R, ~, ~] = svd(randn(3));
t = randn(3, 1);

P = K * [R, t];

% Randomly generate 2D and 3D points
N = 10;
X = randn(3, N);
x = P * [X; ones(1, N)];
x = x(1:2, :) ./ x(3, :);

% Test with clean data
test_pose_estimation(x, X, P, 'clean 2D points');

% Noise performance
% Add some noise
xNoise = x + rand(size(x));
test_pose_estimation(xNoise, X, P, 'noisy 2D points');

function test_pose_estimation(x, X, P, description)
    % Estimate pose
    P_est = estimate_pose(x, X);
    
    % Reproject points
    xProj = P_est * [X; ones(1, size(X, 2))];
    xProj = xProj(1:2, :) ./ xProj(3, :);
    
    % Calculate and print errors
    fprintf('------------------------------\n');
    fprintf('Reprojected Error with %s is %.4f\n', description, norm(xProj - x));
    fprintf('Pose Error with %s is %.4f\n', description, ...
        norm(P_est / P_est(end) - P / P(end)) / norm(P / P(end)));
end