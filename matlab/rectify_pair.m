function [M1, M2, K1n, K2n, R1n, R2n, t1n, t2n] = rectify_pair(K1, K2, R1, R2, t1, t2)
    % Take left and right camera parameters (K, R, T) and return left
    % and right rectification matrices (M1, M2) and updated camera parameters.
    
    % Compute the camera centres
    c1 = -(K1 * R1) \ (K1 * t1);
    c2 = -(K2 * R2) \ (K2 * t2);
    
    % Compute the new rotation matrix
    r1 = (c1 - c2) / norm(c1 - c2); % New x-axis
    r2 = cross(R1(3, :), r1)';      % New y-axis
    r3 = cross(r2, r1);             % New z-axis
    Rn = [r1 r2 r3]';
    
    % Update the rotation and intrinsic matrices
    R1n = Rn;
    R2n = Rn;
    K1n = K2;
    K2n = K2;
    
    % Update the translation vectors
    t1n = -Rn * c1;
    t2n = -Rn * c2;
    
    % Compute the rectification matrices
    M1 = K2 * Rn / (K1 * R1);
    M2 = K2 * Rn / (K2 * R2);
end