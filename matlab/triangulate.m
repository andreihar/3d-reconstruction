function pts3d = triangulate(P1, pts1, P2, pts2)
    % Triangulate estimates the 3D positions of points from 2D correspondences
    %   Args:
    %       P1:     projection matrix with shape 3 x 4 for image 1
    %       pts1:   coordinates of points with shape N x 2 on image 1
    %       P2:     projection matrix with shape 3 x 4 for image 2
    %       pts2:   coordinates of points with shape N x 2 on image 2
    %
    %   Returns:
    %       pts3d:  coordinates of 3D points with shape N x 3

    % Add homogeneous coordinates
    pts1_h = [pts1, ones(size(pts1, 1), 1)];
    pts2_h = [pts2, ones(size(pts2, 1), 1)];
    
    % Initialise the 3D points matrix
    pts3d = zeros(size(pts1, 1), 3);
    
    % Loop through each point pair
    for i = 1:size(pts1, 1)
        % Construct the skew-symmetric matrices
        x1_skew = [0, -pts1_h(i, 3), pts1_h(i, 2);
                   pts1_h(i, 3), 0, -pts1_h(i, 1);
                   -pts1_h(i, 2), pts1_h(i, 1), 0];
        x2_skew = [0, -pts2_h(i, 3), pts2_h(i, 2);
                   pts2_h(i, 3), 0, -pts2_h(i, 1);
                   -pts2_h(i, 2), pts2_h(i, 1), 0];
        
        % Formulate the matrix Q
        Q = [x1_skew * P1; x2_skew * P2];
        
        % Perform SVD
        [~, ~, V] = svd(Q);
        
        % Extract the 3D point
        P_homogeneous = V(:, end);
        pts3d(i, :) = P_homogeneous(1:3)' / P_homogeneous(4);
    end
    
    % Calculate and display the reprojection error
    reprojection_error(P1, pts1, P2, pts2, pts3d);
end

function reprojection_error(P1, pts1, P2, pts2, pts3d)
    % Calculate the reprojection error for the 3D points
    pts3d_h = [pts3d, ones(size(pts3d, 1), 1)]';
    
    % Reproject points onto the images
    pts1_proj = (P1 * pts3d_h)';
    pts1_proj = pts1_proj(:, 1:2) ./ pts1_proj(:, 3);
    pts2_proj = (P2 * pts3d_h)';
    pts2_proj = pts2_proj(:, 1:2) ./ pts2_proj(:, 3);
    
    % Calculate Euclidean distances
    eucl_distance1 = sqrt(sum((pts1 - pts1_proj).^2, 2));
    eucl_distance2 = sqrt(sum((pts2 - pts2_proj).^2, 2));
    
    % Display the mean reprojection error
    mean_error = (mean(eucl_distance1) + mean(eucl_distance2)) / 2;
    disp(['Mean reprojection error: ', num2str(mean_error)]);
end