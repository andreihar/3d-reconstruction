function depthMap = get_depth(disparityMap, K1, K2, R1, R2, t1, t2)
    % Create a depth map from a disparity map (disparityMap).
    % Args:
    %   disparityMap: The disparity map.
    %   K1, K2: Intrinsic matrices of the two cameras.
    %   R1, R2: Rotation matrices of the two cameras.
    %   t1, t2: Translation vectors of the two cameras.
    % Returns:
    %   depthMap: The resulting depth map.
    
    % Compute the camera centres
    cameraCentre1 = -(K1 * R1) \ (K1 * t1);
    cameraCentre2 = -(K2 * R2) \ (K2 * t2);
    
    % Compute the baseline distance between the two camera centres
    baseline = norm(cameraCentre1 - cameraCentre2);
    
    % Compute the focal length from the intrinsic matrix
    focalLength = K1(1, 1);
    
    % Compute the depth map
    depthMap = baseline * focalLength ./ disparityMap;
    
    % Handle infinite values in the depth map
    depthMap(isinf(depthMap)) = 0;
end