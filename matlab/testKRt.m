% Script for testing Pose Estimation

% Randomly generate camera matrix
K = [1, 0, 1e2; 0, 1, 1e2; 0, 0, 1];

[R, ~, ~] = svd(randn(3));
if det(R) < 0
    R = -R;
end
t = randn(3, 1);

P = K * [R, t];

% Randomly generate 2D and 3D points
N = 10;
X = randn(3, N);
x = P * [X; ones(1, N)];
x = x(1:2, :) ./ x(3, :);

% Test with clean data
test_pose_estimation(x, X, K, R, t, 'clean 2D points');

% Noise performance
% Add some noise
xNoise = x + rand(size(x));
test_pose_estimation(xNoise, X, K, R, t, 'noisy 2D points');

function test_pose_estimation(x, X, K, R, t, description)
    % Estimate pose
    P_est = estimate_pose(x, X);
    [K_est, R_est, t_est] = estimate_params(P_est);
    
    % Calculate and print errors
    fprintf('------------------------------\n');
    fprintf('Intrinsic Error with %s is %.4f\n', description, ...
        norm(K_est / K_est(end) - K / K(end)));
    fprintf('Rotation Error with %s is %.4f\n', description, ...
        norm(R_est - R));
    fprintf('Translation Error with %s is %.4f\n', description, ...
        norm(t_est - t));
end