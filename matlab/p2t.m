function mt = p2t(H, m)
    % Check the transformation matrix format
    if ~isequal(size(H), [3, 3])
        error('Incorrect format of the transformation matrix (must be 3x3)');
    end

    % Check the image coordinates format
    if size(m, 1) ~= 2
        error('The image coordinates must be Cartesian');
    end

    % Convert to homogeneous coordinates
    c3d = [m; ones(1, size(m, 2))];
    
    % Apply the transformation
    h2d = H * c3d;
    
    % Convert back to Cartesian coordinates
    mt = h2d(1:2, :) ./ h2d(3, :);
end