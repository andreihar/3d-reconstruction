function F = eightpoint(pts1, pts2, M)
    % eightpoint:
    %   pts1 - Nx2 matrix of (x,y) coordinates
    %   pts2 - Nx2 matrix of (x,y) coordinates
    %   M    - max(imwidth, imheight)

    % Normalise points
    npts1 = pts1 / M;
    npts2 = pts2 / M;

    % Construct matrix U
    U = [npts1(:, 1) .* npts2(:, 1), npts1(:, 1) .* npts2(:, 2), npts1(:, 1), ...
         npts1(:, 2) .* npts2(:, 1), npts1(:, 2) .* npts2(:, 2), npts1(:, 2), ...
         npts2(:, 1), npts2(:, 2), ones(size(pts1, 1), 1)];

    % Compute SVD of U and extract F
    [~, ~, V] = svd(U);
    F = reshape(V(:, end), [3, 3]);

    % Enforce rank 2 constraint
    [U, S, V] = svd(F);
    F = U * diag([S(1,1), S(2,2), 0]) * V';

    % Un-normalise F
    T = diag([1/M, 1/M, 1]);
    F = T' * F * T;
end