function [M2s] = camera2(E)
    % Normalize the essential matrix
    E = E / norm(E);

    % Compute the SVD of the essential matrix
    [U, ~, V] = svd(E);

    % Ensure a proper rotation matrix
    if det(U * V') < 0
        V = -V;
    end

    % Define the W matrix
    W = [0, -1, 0; 1, 0, 0; 0, 0, 1];

    % Compute the four possible camera matrices
    M2s = zeros(3, 4, 4);
    M2s(:, :, 1) = [U * W * V', U(:, 3)];
    M2s(:, :, 2) = [U * W * V', -U(:, 3)];
    M2s(:, :, 3) = [U * W' * V', U(:, 3)];
    M2s(:, :, 4) = [U * W' * V', -U(:, 3)];
end