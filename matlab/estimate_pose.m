function P = estimate_pose(x, X)
    % Compute the pose matrix (camera matrix) P given 2D and 3D points.
    %   Args:
    %       x: 2D points with shape [2, N]
    %       X: 3D points with shape [3, N]
    
    % Number of points
    N = size(x, 2);
    
    % Preallocate the matrix A
    A = zeros(2 * N, 12);
    
    % Construct the matrix A using the given 2D and 3D points
    for i = 1:N
        A(2*i-1, :) = [X(1, i) X(2, i) X(3, i) 1 0 0 0 0 -x(1, i)*X(1, i) -x(1, i)*X(2, i) -x(1, i)*X(3, i) -x(1, i)];
        A(2*i, :) = [0 0 0 0 X(1, i) X(2, i) X(3, i) 1 -x(2, i)*X(1, i) -x(2, i)*X(2, i) -x(2, i)*X(3, i) -x(2, i)];
    end
    
    % Compute the eigenvector corresponding to the smallest eigenvalue
    [eig, ~] = eigs(A' * A, 1, 'SM');
    
    % Reshape the eigenvector into the pose matrix P
    P = reshape(eig, 4, 3)';
end